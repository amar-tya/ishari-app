// How the Supabase and Google sign-outs run, and what a stuck Google call does.
// `testWidgets` only for its fake clock: `pump` advances time, nothing waits.
import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in_platform_interface/google_sign_in_platform_interface.dart';
import 'package:ishari/core/errors/exceptions.dart';
import 'package:ishari/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

const _limit = Duration(seconds: 3);
const _almost = Duration(milliseconds: 2900);
const _rest = Duration(milliseconds: 100);

class _FakeAuth extends Fake implements GoTrueClient {
  bool signOutStarted = false;
  Future<void> Function() onSignOut = () async {};

  @override
  Future<void> signOut({SignOutScope scope = SignOutScope.local}) {
    signOutStarted = true;
    return onSignOut();
  }
}

class _FakeSupabase extends Fake implements SupabaseClient {
  final fakeAuth = _FakeAuth();

  @override
  GoTrueClient get auth => fakeAuth;
}

class _FakeGoogle extends GoogleSignInPlatform {
  final calls = <String>[];
  Future<void> Function() onInit = () async {};
  Future<void> Function() onSignOut = () async {};

  int count(String call) => calls.where((c) => c == call).length;

  @override
  Future<void> init(InitParameters params) {
    calls.add('init');
    return onInit();
  }

  @override
  Stream<AuthenticationEvent>? get authenticationEvents => null;

  @override
  Future<void> signOut(SignOutParams params) {
    calls.add('signOut');
    return onSignOut();
  }

  /// Reaching this means the account picker would open; the user cancels it.
  @override
  Future<AuthenticationResults> authenticate(
    AuthenticateParameters params,
  ) async {
    calls.add('authenticate');
    throw const GoogleSignInException(
      code: GoogleSignInExceptionCode.canceled,
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

/// Watches a future without waiting for it.
class _Outcome {
  _Outcome(Future<Object?> future) {
    unawaited(
      future.then<void>(
        (_) => done = true,
        onError: (Object e) {
          error = e;
          done = true;
        },
      ),
    );
  }

  bool done = false;
  Object? error;
}

Future<void> _hang() => Completer<void>().future;

void main() {
  late _FakeSupabase supabase;
  late _FakeGoogle google;
  late AuthRemoteDataSourceImpl datasource;

  setUp(() {
    supabase = _FakeSupabase();
    google = _FakeGoogle();
    GoogleSignInPlatform.instance = google;
    datasource = AuthRemoteDataSourceImpl(supabase);
  });

  Future<_Outcome> signOut(WidgetTester tester) async {
    final outcome = _Outcome(datasource.signOut().then((_) => null));
    await tester.pump();
    return outcome;
  }

  Future<_Outcome> signIn(WidgetTester tester) async {
    final outcome = _Outcome(datasource.signInWithGoogle());
    await tester.pump();
    return outcome;
  }

  group('signOut runs both at once and waits for both', () {
    testWidgets('Google signs out while the Supabase logout is stalled', (
      tester,
    ) async {
      supabase.fakeAuth.onSignOut = _hang;

      final outcome = await signOut(tester);

      expect(google.calls, ['init', 'signOut']);
      expect(outcome.done, isFalse);
    });

    testWidgets('the Supabase logout starts while Google is stalled', (
      tester,
    ) async {
      google.onInit = _hang;

      await signOut(tester);

      expect(supabase.fakeAuth.signOutStarted, isTrue);
      await tester.pump(_limit);
    });

    testWidgets('waits for Supabase, with no time limit on it', (tester) async {
      final logout = Completer<void>();
      supabase.fakeAuth.onSignOut = () => logout.future;
      final outcome = await signOut(tester);

      await tester.pump(const Duration(minutes: 10));
      expect(outcome.done, isFalse);

      logout.complete();
      await tester.pump();
      expect(outcome.done, isTrue);
      expect(outcome.error, isNull);
    });

    testWidgets('waits for Google after Supabase is done', (tester) async {
      final googleSignOut = Completer<void>();
      google.onSignOut = () => googleSignOut.future;
      final outcome = await signOut(tester);

      await tester.pump(const Duration(seconds: 1));
      expect(outcome.done, isFalse);

      googleSignOut.complete();
      await tester.pump();
      expect(outcome.done, isTrue);
    });

    testWidgets('reports a Supabase error only once Google is done', (
      tester,
    ) async {
      supabase.fakeAuth.onSignOut = () async => throw StateError('storage');
      final googleSignOut = Completer<void>();
      google.onSignOut = () => googleSignOut.future;
      final outcome = await signOut(tester);

      expect(outcome.done, isFalse);

      googleSignOut.complete();
      await tester.pump();
      expect(outcome.error, isA<ServerException>());
    });
  });

  group('the Google part has one time limit', () {
    testWidgets('a hung initialize ends sign-out at the limit', (tester) async {
      google.onInit = _hang;
      final outcome = await signOut(tester);

      await tester.pump(_almost);
      expect(outcome.done, isFalse);
      await tester.pump(_rest);

      expect(outcome.done, isTrue);
      expect(outcome.error, isNull);
      expect(google.calls, isNot(contains('signOut')));
    });

    testWidgets('a hung Google sign-out ends at the limit', (tester) async {
      google.onSignOut = _hang;
      final outcome = await signOut(tester);

      await tester.pump(_almost);
      expect(outcome.done, isFalse);
      await tester.pump(_rest);

      expect(outcome.done, isTrue);
      expect(outcome.error, isNull);
    });

    testWidgets('covers initialize and sign-out together', (tester) async {
      google
        ..onInit = (() => Future<void>.delayed(const Duration(seconds: 2)))
        ..onSignOut = _hang;
      final outcome = await signOut(tester);

      await tester.pump(const Duration(seconds: 2));
      expect(google.calls, contains('signOut'));
      await tester.pump(const Duration(seconds: 1));

      expect(outcome.done, isTrue);
    });

    testWidgets('still reports a Supabase error', (tester) async {
      supabase.fakeAuth.onSignOut = () async => throw StateError('storage');
      google.onSignOut = _hang;
      final outcome = await signOut(tester);

      await tester.pump(_limit);

      expect(outcome.error, isA<ServerException>());
    });

    testWidgets('stays a success after a failed server logout', (tester) async {
      supabase.fakeAuth.onSignOut = () async =>
          throw const AuthException('offline');
      google.onInit = _hang;
      final outcome = await signOut(tester);

      await tester.pump(_limit);

      expect(outcome.done, isTrue);
      expect(outcome.error, isNull);
    });

    testWidgets('an initialize that finishes too late signs nothing out', (
      tester,
    ) async {
      final init = Completer<void>();
      google.onInit = () => init.future;
      await signOut(tester);
      await tester.pump(_limit);

      // A new sign-in may be running by now.
      init.complete();
      await tester.pump();

      expect(google.calls, isNot(contains('signOut')));
    });
  });

  group('the next sign-in', () {
    testWidgets('initializes once when that works', (tester) async {
      await signOut(tester);

      final outcome = await signIn(tester);

      expect(google.calls, ['init', 'signOut', 'authenticate']);
      expect(outcome.error, isA<CanceledSignInException>());
    });

    testWidgets('recovers from an initialize that never completes', (
      tester,
    ) async {
      google.onInit = _hang;
      await signOut(tester);
      await tester.pump(_limit);
      google.onInit = () async {};

      final outcome = await signIn(tester);

      expect(google.count('init'), 2);
      expect(outcome.error, isA<CanceledSignInException>());
    });

    testWidgets('fails at the limit instead of hanging, then can be retried', (
      tester,
    ) async {
      google.onInit = _hang;
      final stuck = await signIn(tester);

      await tester.pump(_almost);
      expect(stuck.done, isFalse);
      await tester.pump(_rest);
      expect(stuck.error, isA<ServerException>());

      google.onInit = () async {};
      final retry = await signIn(tester);

      expect(retry.error, isA<CanceledSignInException>());
    });

    testWidgets('retries an initialize that failed', (tester) async {
      google.onInit = () async => throw StateError('init failed');
      await signOut(tester);
      google.onInit = () async {};

      final outcome = await signIn(tester);

      expect(google.count('init'), 2);
      expect(outcome.error, isA<CanceledSignInException>());
    });

    testWidgets('lets a late Google sign-out finish before the picker', (
      tester,
    ) async {
      final googleSignOut = Completer<void>();
      google.onSignOut = () => googleSignOut.future;
      await signOut(tester);
      await tester.pump(_limit);

      await signIn(tester);
      await tester.pump(const Duration(seconds: 1));
      expect(google.calls, isNot(contains('authenticate')));

      googleSignOut.complete();
      await tester.pump();
      expect(google.calls, contains('authenticate'));
    });

    testWidgets('is not blocked by a Google sign-out that never ends', (
      tester,
    ) async {
      google.onSignOut = _hang;
      await signOut(tester);
      await tester.pump(_limit);

      final outcome = await signIn(tester);
      await tester.pump(_limit);

      expect(outcome.error, isA<CanceledSignInException>());
    });

    testWidgets('goes on when a late Google sign-out fails', (tester) async {
      final googleSignOut = Completer<void>();
      google.onSignOut = () => googleSignOut.future;
      await signOut(tester);
      await tester.pump(_limit);

      final outcome = await signIn(tester);
      googleSignOut.completeError(StateError('clear failed'));
      await tester.pump();

      expect(outcome.error, isA<CanceledSignInException>());
    });
  });
}
