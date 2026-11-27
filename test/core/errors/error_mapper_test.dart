import 'dart:async';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:ishari/core/errors/error_mapper.dart';
import 'package:ishari/core/errors/exceptions.dart';
import 'package:ishari/core/errors/failures.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  final stack = StackTrace.current;
  final logged = <({String message, Object? error, StackTrace? stack})>[];

  void log(String message, {Object? error, StackTrace? stackTrace}) =>
      logged.add((message: message, error: error, stack: stackTrace));

  Failure map(Object error) => mapErrorToFailure(error, stack, log: log);

  setUp(logged.clear);

  group('connection problems', () {
    final errors = <String, Object>{
      'SocketException': const SocketException(
        'Failed host lookup: abcdefgh.supabase.co',
      ),
      'HandshakeException': const HandshakeException('bad certificate'),
      'http ClientException': http.ClientException(
        'Connection reset by peer, uri=https://abcdefgh.supabase.co/rest/v1/x',
      ),
      'AuthRetryableFetchException': AuthRetryableFetchException(
        message: 'offline',
      ),
    };
    errors.forEach((name, error) {
      test('$name is a NetworkFailure', () {
        final failure = map(error);

        expect(failure, isA<NetworkFailure>());
        expect(failure.message, FailureMessages.network);
      });
    });

    test('a timeout is a NetworkFailure with its own text', () {
      final failure = map(
        TimeoutException('took 5s', const Duration(seconds: 5)),
      );

      expect(failure, isA<NetworkFailure>());
      expect(failure.message, FailureMessages.timeout);
    });
  });

  group('PostgrestException', () {
    test('a missing row reads as not found', () {
      final failure = map(
        const PostgrestException(
          message: 'JSON object requested, multiple (or no) rows returned',
          code: 'PGRST116',
        ),
      );

      expect(failure, isA<ServerFailure>());
      expect(failure.message, FailureMessages.notFound);
    });

    test('a permission error reads as forbidden', () {
      final failure = map(
        const PostgrestException(
          message: 'permission denied for table users',
          code: '42501',
        ),
      );

      expect(failure, isA<ServerFailure>());
      expect(failure.message, FailureMessages.forbidden);
    });

    test('anything else gets the general server text', () {
      final failure = map(
        const PostgrestException(
          message: 'column bookmarks.secret_col does not exist',
          code: '42703',
          details: 'Key (email)=(reader@example.com) already exists.',
          hint: 'Perhaps you meant to reference bookmarks.note',
        ),
      );

      expect(failure, isA<ServerFailure>());
      expect(failure.message, FailureMessages.server);
    });
  });

  group('AuthException', () {
    test('a missing session reads as an expired session', () {
      final failure = map(AuthSessionMissingException());

      expect(failure, isA<ServerFailure>());
      expect(failure.message, FailureMessages.sessionExpired);
    });

    test('any other auth error gets the general sign-in text', () {
      final failure = map(
        AuthApiException(
          'Invalid JWT: token abc.def.ghi',
          statusCode: '401',
        ),
      );

      expect(failure, isA<ServerFailure>());
      expect(failure.message, FailureMessages.authFailed);
    });
  });

  group('unexpected errors', () {
    final errors = <String, Object>{
      'FormatException': const FormatException('Unexpected character'),
      'StateError': StateError('Bad state: no element'),
      'NoSuchMethodError': _noSuchMethod(),
    };
    errors.forEach((name, error) {
      test('$name is an UnknownFailure', () {
        final failure = map(error);

        expect(failure, isA<UnknownFailure>());
        expect(failure.message, FailureMessages.unknown);
      });
    });
  });

  group('ServerException', () {
    test('without a cause keeps its own message', () {
      final failure = map(
        const ServerException(message: FailureMessages.googleSignInFailed),
      );

      expect(
        failure,
        const ServerFailure(
          message: 'Gagal masuk dengan Google. Silakan coba lagi.',
        ),
      );
    });

    test('with a cause is judged by the cause', () {
      final failure = map(
        ServerException.from(
          const SocketException('Failed host lookup'),
          stack,
        ),
      );

      expect(failure, isA<NetworkFailure>());
    });

    test('from keeps an existing ServerException as it is', () {
      const original = ServerException(message: 'x');

      expect(ServerException.from(original, stack), same(original));
    });

    test('from keeps the error out of the message', () {
      final wrapped = ServerException.from(
        const PostgrestException(message: 'table secret_table'),
        stack,
      );

      expect(wrapped.message, isNot(contains('secret_table')));
      expect(wrapped.toString(), isNot(contains('secret_table')));
      expect(wrapped.cause, isA<PostgrestException>());
      expect(wrapped.stackTrace, same(stack));
    });
  });

  group('logging', () {
    test('logs the raw cause and the stack where it was thrown', () {
      final thrownAt = StackTrace.current;
      const cause = PostgrestException(message: 'table secret', code: '42P01');

      map(ServerException(cause: cause, stackTrace: thrownAt));

      expect(logged.single.error, same(cause));
      expect(logged.single.stack, same(thrownAt));
    });

    test('logs a plain error with the stack it was caught with', () {
      final error = StateError('boom');

      map(error);

      expect(logged.single.error, same(error));
      expect(logged.single.stack, same(stack));
    });

    test('keeps raw text out of the failure and the log message', () {
      final failure = map(
        const PostgrestException(
          message: 'permission denied for table secret_table',
          code: '99999',
          details: 'reader@example.com',
        ),
      );

      for (final text in [failure.message, logged.single.message]) {
        expect(text, isNot(contains('secret_table')));
        expect(text, isNot(contains('reader@example.com')));
        expect(text, isNot(contains('Exception')));
      }
    });
  });

  group('every user text', () {
    test('is Indonesian and free of technical words', () {
      const texts = [
        FailureMessages.network,
        FailureMessages.timeout,
        FailureMessages.server,
        FailureMessages.notFound,
        FailureMessages.forbidden,
        FailureMessages.sessionExpired,
        FailureMessages.authFailed,
        FailureMessages.googleSignInFailed,
        FailureMessages.signInRequired,
        FailureMessages.unknown,
        FailureMessages.cache,
      ];
      final technical = RegExp(
        r'exception|error|postgrest|supabase|socket|null|table|column|http',
        caseSensitive: false,
      );

      for (final text in texts) {
        expect(text, isNot(matches(technical)), reason: text);
      }
    });

    test('the Failure defaults use them', () {
      expect(const NetworkFailure().message, FailureMessages.network);
      expect(const ServerFailure().message, FailureMessages.server);
      expect(const UnknownFailure().message, FailureMessages.unknown);
      expect(const CacheFailure().message, FailureMessages.cache);
      expect(const ServerException().message, FailureMessages.server);
    });
  });
}

Object _noSuchMethod() {
  try {
    // ignore: avoid_dynamic_calls
    (null as dynamic).length;
  } on Object catch (e) {
    return e;
  }
  throw StateError('unreachable');
}
