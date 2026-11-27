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

/// The texts users see for a failure. Short, Indonesian, and without internals
/// such as table names, hosts or exception names.
abstract final class FailureMessages {
  static const network =
      'Tidak ada koneksi internet. Periksa jaringan Anda lalu coba lagi.';
  static const timeout = 'Koneksi terlalu lambat. Silakan coba lagi.';
  static const server =
      'Terjadi kesalahan pada server. Silakan coba lagi nanti.';
  static const notFound = 'Data tidak ditemukan.';
  static const forbidden = 'Anda tidak memiliki akses ke data ini.';
  static const sessionExpired = 'Sesi Anda telah berakhir. Silakan masuk lagi.';
  static const authFailed = 'Gagal masuk. Silakan coba lagi.';
  static const googleSignInFailed =
      'Gagal masuk dengan Google. Silakan coba lagi.';
  static const signInRequired = 'Silakan masuk terlebih dahulu.';
  static const unknown = 'Terjadi kesalahan. Silakan coba lagi.';
  static const cache = 'Gagal membaca data tersimpan di perangkat.';
}

/// Failure originating from a remote server (Supabase, API).
final class ServerFailure extends Failure {
  const ServerFailure({super.message = FailureMessages.server});
}

/// Failure originating from local storage.
final class CacheFailure extends Failure {
  const CacheFailure({super.message = FailureMessages.cache});
}

/// Failure when there is no internet connection.
final class NetworkFailure extends Failure {
  const NetworkFailure({super.message = FailureMessages.network});
}

/// Failure for unexpected/unknown errors.
final class UnknownFailure extends Failure {
  const UnknownFailure({super.message = FailureMessages.unknown});
}

/// Failure when user cancels the sign-in flow (not an error — no toast needed).
final class CanceledFailure extends Failure {
  const CanceledFailure() : super(message: 'login_canceled');
}
