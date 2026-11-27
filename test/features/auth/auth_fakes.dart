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

const testUser = UserEntity(id: 'user-1', email: 'user@example.com');

/// An [AuthRepository] whose answers and SDK stream the test drives.
class ControllableAuthRepository extends Fake implements AuthRepository {
  final changes = StreamController<UserEntity?>.broadcast();

  /// What the startup check finds, unless [currentUser] is set.
  UserEntity? sessionUser;

  Future<Either<Failure, UserEntity?>> Function()? currentUser;

  Future<Either<Failure, UserEntity>> Function() signIn = () async =>
      right(testUser);

  Future<Either<Failure, Unit>> Function() signOutResult = () async =>
      right(unit);

  @override
  Stream<UserEntity?> get authStateChanges => changes.stream;

  @override
  Future<Either<Failure, UserEntity?>> getCurrentUser() =>
      currentUser?.call() ?? Future.value(right(sessionUser));

  @override
  Future<Either<Failure, UserEntity>> signInWithGoogle() => signIn();

  @override
  Future<Either<Failure, Unit>> signOut() => signOutResult();
}

class _SilentAnalytics extends Fake implements AnalyticsService {
  @override
  Future<void> logLogin() async {}
}

AuthBloc buildControllableAuthBloc(AuthRepository repository) => AuthBloc(
  SignInWithGoogle(repository),
  SignOut(repository),
  GetCurrentUser(repository),
  _SilentAnalytics(),
  WatchAuthState(repository),
);
