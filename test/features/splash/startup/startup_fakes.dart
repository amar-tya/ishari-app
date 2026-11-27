import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:ishari/core/analytics/analytics_service.dart';
import 'package:ishari/core/errors/failures.dart';
import 'package:ishari/features/auth/domain/entities/user_entity.dart';
import 'package:ishari/features/auth/domain/repositories/auth_repository.dart';
import 'package:ishari/features/auth/domain/usecases/get_current_user.dart';
import 'package:ishari/features/auth/domain/usecases/sign_in_with_google.dart';
import 'package:ishari/features/auth/domain/usecases/sign_out.dart';
import 'package:ishari/features/auth/domain/usecases/watch_auth_state.dart';
import 'package:ishari/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:ishari/features/update/domain/entities/app_version_entity.dart';
import 'package:ishari/features/update/domain/repositories/update_repository.dart';
import 'package:ishari/features/update/domain/usecases/check_for_update.dart';
import 'package:ishari/features/update/presentation/cubit/update_cubit.dart';

typedef CurrentUserResult = Future<Either<Failure, UserEntity?>>;

CurrentUserResult signedOut() async => right(null);

/// Never completes, like an auth check stuck on a dead connection.
CurrentUserResult hungAuth() =>
    Completer<Either<Failure, UserEntity?>>().future;

class FakeAuthRepository extends Fake implements AuthRepository {
  CurrentUserResult Function() currentUser = signedOut;

  @override
  CurrentUserResult getCurrentUser() => currentUser();

  @override
  Stream<UserEntity?> get authStateChanges => const Stream.empty();
}

class FakeAnalyticsService extends Fake implements AnalyticsService {}

AuthBloc buildAuthBloc(FakeAuthRepository repository) => AuthBloc(
  SignInWithGoogle(repository),
  SignOut(repository),
  GetCurrentUser(repository),
  FakeAnalyticsService(),
  WatchAuthState(repository),
);

const currentVersion = AppVersionEntity(
  minVersion: '1.0.0',
  latestVersion: '1.0.0',
  storeUrl: '',
  releaseNotes: '',
);

class FakeUpdateRepository implements UpdateRepository {
  Future<Either<Failure, AppVersionEntity>> Function() version = () async =>
      right(currentVersion);

  int calls = 0;

  @override
  Future<Either<Failure, AppVersionEntity>> getAppVersion(String platform) {
    calls++;
    return version();
  }
}

UpdateCubit buildUpdateCubit(FakeUpdateRepository repository) =>
    UpdateCubit(CheckForUpdate(repository));
