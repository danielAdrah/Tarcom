import '../error/failures.dart';

/// Hand-written Either-like type used between Data and Domain layers.
/// Repositories return [Result]; use cases forward it; BLoCs fold it.
sealed class Result<T> {
  const Result();

  const factory Result.success(T data) = Success<T>;
  const factory Result.failure(Failure failure) = Err<T>;

  bool get isSuccess => this is Success<T>;
  bool get isFailure => this is Err<T>;

  /// Handle both cases in one expression.
  R when<R>({
    required R Function(T data) success,
    required R Function(Failure failure) failure,
  }) {
    final self = this;
    return switch (self) {
      Success<T>() => success(self.data),
      Err<T>() => failure(self.failure),
    };
  }

  /// Transform the success value, keep the failure untouched.
  Result<R> map<R>(R Function(T data) transform) {
    final self = this;
    return switch (self) {
      Success<T>() => Result.success(transform(self.data)),
      Err<T>() => Result.failure(self.failure),
    };
  }
}

final class Success<T> extends Result<T> {
  const Success(this.data);
  final T data;
}

final class Err<T> extends Result<T> {
  const Err(this.failure);
  final Failure failure;
}
