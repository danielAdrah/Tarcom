import '../result/result.dart';
import 'exceptions.dart';
import 'failures.dart';

Failure mapExceptionToFailure(Object error) {
  return switch (error) {
    NetworkException() => NetworkFailure(error.message),
    RequestTimeoutException() => TimeoutFailure(error.message),
    UnauthorizedException() => UnauthorizedFailure(error.message),
    ForbiddenException() => ForbiddenFailure(error.message),
    NotFoundException() => NotFoundFailure(error.message),
    ValidationException() => ValidationFailure(error.message, error.details),
    ServerException() => ServerFailure(error.message, error.statusCode),
    UnknownException() => UnknownFailure(error.message),
    _ => const UnknownFailure(),
  };
}

/// Used by every RepositoryImpl so error handling is written once:
///
/// ```dart
/// Future<Result<List<X>>> getX() => guard(() async {
///   final models = await remote.getX();
///   return models.map((m) => m.toEntity()).toList();
/// });
/// ```
Future<Result<T>> guard<T>(Future<T> Function() action) async {
  try {
    return Result.success(await action());
  } catch (e) {
    return Result.failure(mapExceptionToFailure(e));
  }
}
