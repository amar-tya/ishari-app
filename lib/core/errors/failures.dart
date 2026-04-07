import 'package:meta/meta.dart';

/// Base failure class — use with fpdart Either<Failure, T>.
@immutable
sealed class Failure {
  const Failure({required this.message});

  final String message;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Failure &&
          runtimeType == other.runtimeType &&
          message == other.message;

  @override
  int get hashCode => runtimeType.hashCode ^ message.hashCode;
}

/// Failure originating from a remote server (Supabase, API).
final class ServerFailure extends Failure {
  const ServerFailure({super.message = 'Server failure'});
}

/// Failure originating from local storage.
final class CacheFailure extends Failure {
  const CacheFailure({super.message = 'Cache failure'});
}

/// Failure when there is no internet connection.
final class NetworkFailure extends Failure {
  const NetworkFailure({super.message = 'No internet connection'});
}

/// Failure for unexpected/unknown errors.
final class UnknownFailure extends Failure {
  const UnknownFailure({super.message = 'Unknown failure'});
}

/// Failure when user cancels the sign-in flow (not an error — no toast needed).
final class CanceledFailure extends Failure {
  const CanceledFailure() : super(message: 'login_canceled');
}
