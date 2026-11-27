// What signInWithGoogle throws, and the text a user would end up with.
// Nothing here reaches Google or Supabase: both are fakes.
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in_platform_interface/google_sign_in_platform_interface.dart';
import 'package:ishari/core/errors/error_mapper.dart';
import 'package:ishari/core/errors/exceptions.dart';
import 'package:ishari/core/errors/failures.dart';
import 'package:ishari/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class _FakeSupabase extends Fake implements SupabaseClient {}

/// Plays the scripted [authenticate] outcomes in order.
class _FakeGoogle extends GoogleSignInPlatform {
  _FakeGoogle(this.outcomes);

  final List<Object> outcomes;
  final calls = <String>[];

  @override
  Future<void> init(InitParameters params) async => calls.add('init');

  @override
  Stream<AuthenticationEvent>? get authenticationEvents => null;

  @override
  Future<void> signOut(SignOutParams params) async => calls.add('signOut');

  @override
  Future<AuthenticationResults> authenticate(
    AuthenticateParameters params,
  ) async {
    calls.add('authenticate');
    throw outcomes.removeAt(0);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  late _FakeGoogle google;

  AuthRemoteDataSourceImpl datasource(List<Object> outcomes) {
    google = _FakeGoogle(outcomes);
    GoogleSignInPlatform.instance = google;
    return AuthRemoteDataSourceImpl(_FakeSupabase());
  }

  Future<Object> failureOf(Future<Object?> future) async {
    try {
      await future;
    } on Object catch (e) {
      return e;
    }
    fail('expected an error');
  }

  test('a user cancel stays a CanceledSignInException', () async {
    final error = await failureOf(
      datasource([
        const GoogleSignInException(code: GoogleSignInExceptionCode.canceled),
      ]).signInWithGoogle(),
    );

    expect(error, isA<CanceledSignInException>());
  });

  test('a "[16]" cancel clears the credential and asks again', () async {
    final error = await failureOf(
      datasource([
        const GoogleSignInException(
          code: GoogleSignInExceptionCode.canceled,
          description: '[16] Account reauth failed',
        ),
        const GoogleSignInException(code: GoogleSignInExceptionCode.canceled),
      ]).signInWithGoogle(),
    );

    expect(google.calls, ['init', 'authenticate', 'signOut', 'authenticate']);
    expect(error, isA<CanceledSignInException>());
  });

  test('a "[16]" retry that fails again is not a user cancel', () async {
    final error = await failureOf(
      datasource([
        const GoogleSignInException(
          code: GoogleSignInExceptionCode.canceled,
          description: '[16] Account reauth failed',
        ),
        const GoogleSignInException(
          code: GoogleSignInExceptionCode.canceled,
          description: '[16] Account reauth failed',
        ),
      ]).signInWithGoogle(),
    );

    expect(error, isA<ServerException>());
  });

  test(
    'another Google failure gets a general text without the details',
    () async {
      final error = await failureOf(
        datasource([
          const GoogleSignInException(
            code: GoogleSignInExceptionCode.clientConfigurationError,
            description: '[10] DEVELOPER_ERROR sha1 abc123',
          ),
        ]).signInWithGoogle(),
      );

      expect(error, isA<ServerException>());
      final exception = error as ServerException;
      expect(exception.message, FailureMessages.googleSignInFailed);
      expect(exception.cause, isNull);
      expect(
        mapErrorToFailure(
          exception,
          StackTrace.empty,
          log: (_, {error, stackTrace}) {},
        ),
        const ServerFailure(message: FailureMessages.googleSignInFailed),
      );
    },
  );

  test('a network error is wrapped with the original as its cause', () async {
    const socket = SocketException('Failed host lookup: abcdefgh.supabase.co');
    final error = await failureOf(
      datasource([socket]).signInWithGoogle(),
    );

    expect(error, isA<ServerException>());
    final exception = error as ServerException;
    expect(exception.cause, same(socket));
    expect(exception.message, isNot(contains('supabase.co')));
    final failure = mapErrorToFailure(
      exception,
      StackTrace.empty,
      log: (_, {error, stackTrace}) {},
    );
    expect(failure, isA<NetworkFailure>());
  });
}
