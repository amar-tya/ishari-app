/// Thrown when a server-side error occurs (Supabase, HTTP, etc.)
class ServerException implements Exception {
  const ServerException({this.message = 'Server error occurred'});

  final String message;

  @override
  String toString() => 'ServerException: $message';
}

/// Thrown when reading/writing to local secure storage fails
class CacheException implements Exception {
  const CacheException({this.message = 'Cache error occurred'});

  final String message;

  @override
  String toString() => 'CacheException: $message';
}

/// Thrown when there is no internet connection
class NetworkException implements Exception {
  const NetworkException({this.message = 'No internet connection'});

  final String message;

  @override
  String toString() => 'NetworkException: $message';
}
