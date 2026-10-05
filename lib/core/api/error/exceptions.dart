/// Thrown by ApiClient / data sources. Repositories convert them to Failures.
sealed class AppException implements Exception {
  const AppException([this.message]);
  final String? message;
}

final class NetworkException extends AppException {
  const NetworkException([super.message]);
}

final class RequestTimeoutException extends AppException {
  const RequestTimeoutException([super.message]);
}

final class UnauthorizedException extends AppException {
  const UnauthorizedException([super.message]);
}

final class ForbiddenException extends AppException {
  const ForbiddenException([super.message]);
}

final class NotFoundException extends AppException {
  const NotFoundException([super.message]);
}

final class ValidationException extends AppException {
  const ValidationException([super.message, this.details]);
  final Object? details;
}

final class ServerException extends AppException {
  const ServerException([super.message, this.statusCode]);
  final int? statusCode;
}

final class UnknownException extends AppException {
  const UnknownException([super.message]);
}
