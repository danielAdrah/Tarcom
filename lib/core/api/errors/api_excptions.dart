class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final String? code;
  final Map<String, dynamic>? errors;

  const ApiException({
    required this.message,
    this.statusCode,
    this.code,
    this.errors,
  });

  @override
  String toString() {
    return 'ApiException('
        'message: $message, '
        'statusCode: $statusCode, '
        'code: $code, '
        'errors: $errors'
        ')';
  }
}

class NetworkException extends ApiException {
  const NetworkException({
    String message = 'تعذر الاتصال بالخادم. تحقق من اتصال الإنترنت.',
  }) : super(message: message);
}

class TimeoutException extends ApiException {
  const TimeoutException({String message = 'انتهت مهلة الاتصال بالخادم.'})
    : super(message: message);
}

class UnauthorizedException extends ApiException {
  const UnauthorizedException({
    String message = 'غير مصرح لك بتنفيذ هذه العملية.',
  }) : super(message: message, statusCode: 401);
}

class ForbiddenException extends ApiException {
  const ForbiddenException({
    String message = 'ليس لديك صلاحية لتنفيذ هذه العملية.',
  }) : super(message: message, statusCode: 403);
}

class NotFoundException extends ApiException {
  const NotFoundException({String message = 'المطلوب غير موجود.'})
    : super(message: message, statusCode: 404);
}

class ValidationException extends ApiException {
  const ValidationException({
    required String message,
    int? statusCode,
    Map<String, dynamic>? errors,
  }) : super(message: message, statusCode: statusCode, errors: errors);
}

class ServerException extends ApiException {
  const ServerException({
    String message = 'حدث خطأ في الخادم. حاول مرة أخرى لاحقاً.',
    int? statusCode,
  }) : super(message: message, statusCode: statusCode);
}

class UnknownApiException extends ApiException {
  const UnknownApiException({String message = 'حدث خطأ غير متوقع.'})
    : super(message: message);
}
