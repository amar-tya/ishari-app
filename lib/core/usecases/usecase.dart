import 'package:fpdart/fpdart.dart';
import 'package:ishari/core/errors/failures.dart';

/// Base use case contract following Clean Architecture.
///
/// [R]      — the return type on success
/// [Params] — input parameters (use [NoParams] for no-arg use cases)
abstract interface class UseCase<R, Params> {
  Future<Either<Failure, R>> call(Params params);
}

/// Sentinel type for use cases that take no parameters.
final class NoParams {
  const NoParams();
}
