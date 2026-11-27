import 'dart:async';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:ishari/core/errors/exceptions.dart';
import 'package:ishari/core/errors/failures.dart';
import 'package:ishari/core/utils/app_logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Where the raw error goes. Defaults to [AppLogger.e].
typedef ErrorLog =
    void Function(String message, {Object? error, StackTrace? stackTrace});

void _defaultLog(String message, {Object? error, StackTrace? stackTrace}) =>
    appLogger.e(message, error: error, stackTrace: stackTrace);

// PostgREST / PostgreSQL codes that get their own text.
const _kNoRowForSingle = 'PGRST116';
const _kInsufficientPrivilege = '42501';

/// Turns a caught [error] into a [Failure] that is safe to show to the user.
///
/// The raw error and its stack go to [log] only. Nothing from the error text
/// (messages, details, hints, table or column names) goes into the failure.
/// A [ServerException] is looked through to the [ServerException.cause] it
/// wraps. A [ServerException] with no cause was written by the app with a
/// message meant for the user, so that message is kept.
Failure mapErrorToFailure(
  Object error,
  StackTrace stackTrace, {
  ErrorLog log = _defaultLog,
}) {
  if (error is ServerException && error.cause == null) {
    log(
      '[ErrorMapper] ServerException: ${error.message}',
      stackTrace: stackTrace,
    );
    return ServerFailure(message: error.message);
  }

  final raw = error is ServerException ? error.cause! : error;
  final rawStack =
      (error is ServerException ? error.stackTrace : null) ?? stackTrace;
  final failure = _classify(raw);
  log(
    '[ErrorMapper] ${failure.runtimeType}',
    error: raw,
    stackTrace: rawStack,
  );
  return failure;
}

Failure _classify(Object raw) => switch (raw) {
  SocketException() ||
  HandshakeException() ||
  http.ClientException() ||
  AuthRetryableFetchException() => const NetworkFailure(),
  TimeoutException() => const NetworkFailure(message: FailureMessages.timeout),
  PostgrestException() => _fromPostgrest(raw),
  AuthSessionMissingException() => const ServerFailure(
    message: FailureMessages.sessionExpired,
  ),
  AuthException() => const ServerFailure(message: FailureMessages.authFailed),
  _ => const UnknownFailure(),
};

Failure _fromPostgrest(PostgrestException e) {
  if (e.code == _kNoRowForSingle) {
    return const ServerFailure(message: FailureMessages.notFound);
  }
  if (e.code == _kInsufficientPrivilege) {
    return const ServerFailure(message: FailureMessages.forbidden);
  }
  return const ServerFailure();
}
