/// Thrown when a server-side error occurs (Supabase, HTTP, etc.)
///
/// [message] may be shown to the user, so it must be plain Indonesian text
/// without internals. The error that was actually caught goes in [cause], and
/// only the logger reads it. Use [ServerException.from] to wrap a caught error.
class ServerException implements Exception {
  const ServerException({
    this.message = 'Terjadi kesalahan pada server. Silakan coba lagi nanti.',
    this.cause,
    this.stackTrace,
  });

  /// Wraps [error], which is kept in [cause] and not copied into [message].
  /// An error that already is a [ServerException] is returned as it is.
  factory ServerException.from(Object error, StackTrace stackTrace) {
    if (error is ServerException) return error;
    return ServerException(
      message: 'Request failed (${error.runtimeType})',
      cause: error,
      stackTrace: stackTrace,
    );
  }

  final String message;

  /// The error that was caught, if this exception wraps one.
  final Object? cause;

  /// Where [cause] was thrown.
  final StackTrace? stackTrace;

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

/// Thrown when user explicitly cancels the Google Sign-In flow.
class CanceledSignInException implements Exception {
  const CanceledSignInException();
}
