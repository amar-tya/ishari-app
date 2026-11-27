import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:ishari/core/errors/exceptions.dart';

/// Keys used for secure storage entries.
abstract final class _StorageKeys {
  /// Written by older app versions; now only deleted.
  static const String cachedUser = 'cached_user';
}

/// Contract for local secure storage operations on auth data.
abstract interface class AuthLocalDataSource {
  /// Remove the cached user left by older app versions.
  Future<void> clearCachedUser();
}

@LazySingleton(as: AuthLocalDataSource)
class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  const AuthLocalDataSourceImpl(this._secureStorage);

  final FlutterSecureStorage _secureStorage;

  @override
  Future<void> clearCachedUser() async {
    try {
      await _secureStorage.delete(key: _StorageKeys.cachedUser);
    } catch (e) {
      throw CacheException(message: e.toString());
    }
  }
}
