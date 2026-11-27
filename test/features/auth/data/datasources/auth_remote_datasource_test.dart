// The real Supabase client against a server on 127.0.0.1, so nothing leaves
// the machine. Deliberately plain `test()`: the widget test binding would
// replace HttpClient with a stub.
import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in_platform_interface/google_sign_in_platform_interface.dart';
import 'package:ishari/core/errors/exceptions.dart';
import 'package:ishari/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:ishari/features/auth/data/models/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../loopback_auth.dart';

class _FakeGoogleSignInPlatform extends GoogleSignInPlatform {
  final calls = <String>[];
  bool failInit = false;
  bool failSignOut = false;

  @override
  Future<void> init(InitParameters params) async {
    calls.add('init started');
    await Future<void>.delayed(const Duration(milliseconds: 10));
    if (failInit) throw StateError('init failed');
    calls.add('init done');
  }

  @override
  Stream<AuthenticationEvent>? get authenticationEvents => null;

  @override
  Future<void> signOut(SignOutParams params) async {
    calls.add('signOut');
    if (failSignOut) throw StateError('google sign-out failed');
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

/// Throws something that is not an [AuthException] from inside
/// `auth.signOut()`, like a broken local storage plugin.
class _BrokenAuthStorage extends GotrueAsyncStorage {
  const _BrokenAuthStorage();

  @override
  Future<String?> getItem({required String key}) async => null;

  @override
  Future<void> removeItem({required String key}) async =>
      throw StateError('storage plugin failed');

  @override
  Future<void> setItem({required String key, required String value}) async {}
}

void main() {
  late LoopbackAuthServer server;
  late _FakeGoogleSignInPlatform google;
  late SupabaseClient client;
  late AuthRemoteDataSourceImpl datasource;
  late List<AuthChangeEvent> events;
  late List<Object> streamErrors;
  StreamSubscription<AuthState>? subscription;

  // Auto refresh defaults to off so no timer races the sign-out cases.
  Future<void> setUpClient({
    GotrueAsyncStorage? authStorage,
    bool autoRefresh = false,
  }) async {
    client = SupabaseClient(
      server.url,
      'anon-key',
      authOptions: AuthClientOptions(
        autoRefreshToken: autoRefresh,
        authFlowType: AuthFlowType.implicit,
        pkceAsyncStorage: authStorage,
      ),
    );
    datasource = AuthRemoteDataSourceImpl(client);
    subscription = client.auth.onAuthStateChange.listen(
      (state) => events.add(state.event),
      onError: (Object error) => streamErrors.add(error),
    );
  }

  Future<void> signIn() => client.auth.setInitialSession(
    sessionJson(expiresIn: const Duration(hours: 1)),
  );

  setUp(() async {
    server = await LoopbackAuthServer.start();
    google = _FakeGoogleSignInPlatform();
    GoogleSignInPlatform.instance = google;
    events = [];
    streamErrors = [];
  });

  tearDown(() async {
    await subscription?.cancel();
    await client.dispose();
    await server.goOffline();
  });

  group('signOut', () {
    test('signs out of Supabase and of an initialized Google', () async {
      await setUpClient();
      await signIn();

      await datasource.signOut();

      expect(server.requests, ['/auth/v1/logout']);
      expect(client.auth.currentSession, isNull);
      expect(google.calls, ['init started', 'init done', 'signOut']);
    });

    test('offline removes the session and does not throw', () async {
      await setUpClient();
      await signIn();
      await server.goOffline();

      await datasource.signOut();
      await pumpEventQueue();

      expect(client.auth.currentSession, isNull);
      expect(events, contains(AuthChangeEvent.signedOut));
      expect(google.calls, contains('signOut'));
    });

    test('a failing server logout does not throw', () async {
      await setUpClient();
      await signIn();
      server
        ..status = 500
        ..body = '{"msg":"unavailable"}';

      await datasource.signOut();

      expect(client.auth.currentSession, isNull);
    });

    test('a failing Google sign-out does not throw', () async {
      await setUpClient();
      await signIn();
      google.failSignOut = true;

      await datasource.signOut();

      expect(client.auth.currentSession, isNull);
    });

    test('a failing Google initialization does not throw', () async {
      await setUpClient();
      await signIn();
      google.failInit = true;

      await datasource.signOut();

      expect(client.auth.currentSession, isNull);
      expect(google.calls, isNot(contains('signOut')));
    });

    test('any other Supabase error is reported, Google still runs', () async {
      await setUpClient(authStorage: const _BrokenAuthStorage());
      await signIn();

      await expectLater(datasource.signOut(), throwsA(isA<ServerException>()));

      expect(google.calls, contains('signOut'));
    });
  });

  // These pin SDK behaviour that the "session is the only truth" design relies
  // on. A failure here after a package upgrade means the design needs a look.
  group('Supabase session refresh', () {
    test(
      'keeps the session when the refresh cannot reach the server',
      () async {
        // On, as in the app: without it the SDK signs an expired session out.
        await setUpClient(autoRefresh: true);
        await server.goOffline();
        final expired = sessionJson(expiresIn: const Duration(hours: -1));

        // The same two steps Supabase.initialize runs at startup.
        await client.auth.setInitialSession(expired);
        await expectLater(
          client.auth.recoverSession(expired),
          throwsA(isA<AuthRetryableFetchException>()),
        );
        await pumpEventQueue();

        expect(client.auth.currentSession, isNotNull);
        expect(events, isNot(contains(AuthChangeEvent.signedOut)));
        expect(streamErrors, isNotEmpty);
        expect(
          await datasource.getCurrentUser(),
          isA<UserModel>().having((u) => u.id, 'id', 'user-1'),
        );
      },
      timeout: const Timeout(Duration(minutes: 1)),
    );

    test('a rejected refresh token removes the session', () async {
      await setUpClient();
      await signIn();
      final users = <UserModel?>[];
      final userSubscription = datasource.authStateChanges.listen(
        users.add,
        onError: (Object _) {},
      );
      addTearDown(userSubscription.cancel);
      await pumpEventQueue();
      server
        ..status = 400
        ..body = '{"error_code":"refresh_token_not_found","msg":"revoked"}';

      await expectLater(
        client.auth.refreshSession(),
        throwsA(isA<AuthException>()),
      );
      await pumpEventQueue();

      expect(client.auth.currentSession, isNull);
      expect(events, contains(AuthChangeEvent.signedOut));
      expect(users.last, isNull);
      expect(await datasource.getCurrentUser(), isNull);
    });
  });
}
