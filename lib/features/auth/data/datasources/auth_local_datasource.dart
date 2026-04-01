import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:ishari/core/errors/exceptions.dart';
import 'package:ishari/features/auth/data/models/user_model.dart';

/// Keys used for secure storage entries.
abstract final class _StorageKeys {
  static const String cachedUser = 'cached_user';
}

/// Contract for local secure storage operations on auth data.
abstract interface class AuthLocalDataSource {
  /// Retrieve the last cached [UserModel].
  /// Throws [CacheException] if nothing is cached.
  Future<UserModel> getCachedUser();

  /// Persist [user] encrypted to the device keychain/keystore.
  Future<void> cacheUser(UserModel user);

  /// Remove cached user data (on sign-out).
  Future<void> clearCachedUser();
}

@LazySingleton(as: AuthLocalDataSource)
class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  const AuthLocalDataSourceImpl(this._secureStorage);

  final FlutterSecureStorage _secureStorage;

  @override
  Future<UserModel> getCachedUser() async {
    try {
      final jsonString = await _secureStorage.read(
        key: _StorageKeys.cachedUser,
      );
      if (jsonString == null) {
        throw const CacheException(message: 'No cached user found');
      }
      return UserModel.fromJson(
        json.decode(jsonString) as Map<String, dynamic>,
      );
    } on CacheException {
      rethrow;
    } catch (e) {
      throw CacheException(message: e.toString());
    }
  }

  @override
  Future<void> cacheUser(UserModel user) async {
    try {
      await _secureStorage.write(
        key: _StorageKeys.cachedUser,
        value: json.encode(user.toJson()),
      );
    } catch (e) {
      throw CacheException(message: e.toString());
    }
  }

  @override
  Future<void> clearCachedUser() async {
    try {
      await _secureStorage.delete(key: _StorageKeys.cachedUser);
    } catch (e) {
      throw CacheException(message: e.toString());
    }
  }
}
