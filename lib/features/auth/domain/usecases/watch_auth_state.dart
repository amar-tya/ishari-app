import 'package:injectable/injectable.dart';
import 'package:ishari/features/auth/domain/entities/user_entity.dart';
import 'package:ishari/features/auth/domain/repositories/auth_repository.dart';

/// Follows the session after startup: emits the signed-in user, or null once
/// there is no session.
@lazySingleton
class WatchAuthState {
  const WatchAuthState(this._repository);

  final AuthRepository _repository;

  Stream<UserEntity?> call() => _repository.authStateChanges;
}
