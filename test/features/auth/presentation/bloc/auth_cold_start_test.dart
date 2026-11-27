// Cold starts with the real Supabase client, data layer and bloc against a
// server on 127.0.0.1. Deliberately plain `test()`: the widget test binding
// would replace HttpClient with a stub.
//
// At startup `Supabase.initialize` restores the saved session
// (`setInitialSession`, awaited) and then refreshes it (`recoverSession`, not
// awaited). The bloc is built after that, so the refresh can finish on either
// side of it.
import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:ishari/core/network/network_info.dart';
import 'package:ishari/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:ishari/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:ishari/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:ishari/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthState;

import '../../auth_fakes.dart';
import '../../loopback_auth.dart';

class _NoLegacyCache implements AuthLocalDataSource {
  @override
  Future<void> clearCachedUser() async {}
}

class _Online implements NetworkInfo {
  @override
  Future<bool> get isConnected async => true;
}

void main() {
  late LoopbackAuthServer server;
  late SupabaseClient client;
  final expired = sessionJson(expiresIn: const Duration(hours: -1));

  setUp(() async {
    server = await LoopbackAuthServer.start();
    client = SupabaseClient(
      server.url,
      'anon-key',
      authOptions: const AuthClientOptions(
        authFlowType: AuthFlowType.implicit,
      ),
    );
    // Auto refresh ticks once right after construction. Let that pass while
    // there is no session, as it does while the app is still reading storage.
    await pumpEventQueue();
  });

  tearDown(() async {
    await client.dispose();
    await server.goOffline();
  });

  void serverRejectsRefresh() => server
    ..status = 400
    ..body = '{"error_code":"refresh_token_not_found","msg":"revoked"}';

  Future<AuthBloc> startBloc() async {
    final bloc = buildControllableAuthBloc(
      AuthRepositoryImpl(
        AuthRemoteDataSourceImpl(client),
        _NoLegacyCache(),
        _Online(),
      ),
    );
    addTearDown(bloc.close);
    bloc.add(const AuthEvent.checkAuthStatus());
    await pumpEventQueue();
    return bloc;
  }

  bool isAuthenticated(AuthBloc bloc) =>
      bloc.state.maybeWhen(authenticated: (_) => true, orElse: () => false);

  Future<void> refreshAtStartup({required Matcher fails}) async {
    await expectLater(client.auth.recoverSession(expired), throwsA(fails));
    await pumpEventQueue();
  }

  test('rejected after the bloc is up (the usual order, as the refresh needs '
      'a round trip): signed out with the notice', () async {
    await client.auth.setInitialSession(expired);
    final bloc = await startBloc();
    expect(isAuthenticated(bloc), isTrue);
    serverRejectsRefresh();

    await refreshAtStartup(fails: isA<AuthApiException>());

    expect(bloc.state, const AuthState.unauthenticated());
    expect(bloc.takeSessionExpiredNotice(), isTrue);
  });

  // Known gap: a bloc subscribing now is replayed only the SDK's error, and
  // the removed session leaves nothing to tell it apart from a first launch.
  test(
    'rejected before the bloc exists: signed out without the notice',
    () async {
      await client.auth.setInitialSession(expired);
      serverRejectsRefresh();
      await refreshAtStartup(fails: isA<AuthApiException>());

      final bloc = await startBloc();

      expect(bloc.state, const AuthState.unauthenticated());
      expect(bloc.takeSessionExpiredNotice(), isFalse);
    },
  );

  test(
    'offline with an expired token: stays signed in, no notice',
    () async {
      await client.auth.setInitialSession(expired);
      final bloc = await startBloc();
      await server.goOffline();

      await refreshAtStartup(fails: isA<AuthRetryableFetchException>());

      expect(isAuthenticated(bloc), isTrue);
      expect(bloc.takeSessionExpiredNotice(), isFalse);
    },
    timeout: const Timeout(Duration(minutes: 1)),
  );

  test('no saved session: signed out without the notice', () async {
    final bloc = await startBloc();

    expect(bloc.state, const AuthState.unauthenticated());
    expect(bloc.takeSessionExpiredNotice(), isFalse);
  });
}
