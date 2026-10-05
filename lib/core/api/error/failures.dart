import 'package:equatable/equatable.dart';

/// What the Domain / Presentation layers see. No raw exceptions leak to the UI.
sealed class Failure extends Equatable {
  const Failure([this.message]);

  /// Message supplied by the backend, when it supplied one. May be null;
  /// the UI decides the Arabic fallback text per failure type.
  final String? message;

  @override
  List<Object?> get props => [message];
}

final class NetworkFailure extends Failure {
  const NetworkFailure([super.message]);
}

final class TimeoutFailure extends Failure {
  const TimeoutFailure([super.message]);
}

final class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure([super.message]);
}

final class ForbiddenFailure extends Failure {
  const ForbiddenFailure([super.message]);
}

final class NotFoundFailure extends Failure {
  const NotFoundFailure([super.message]);
}

final class ValidationFailure extends Failure {
  const ValidationFailure([super.message, this.details]);

  /// Raw validation payload from the backend (shape unknown until API docs).
  final Object? details;

  @override
  List<Object?> get props => [message, details];
}

final class ServerFailure extends Failure {
  const ServerFailure([super.message, this.statusCode]);
  final int? statusCode;

  @override
  List<Object?> get props => [message, statusCode];
}

final class UnknownFailure extends Failure {
  const UnknownFailure([super.message]);
}
