import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../apiKeys/end_point.dart';
import '../errors/api_excptions.dart';

class ApiClient {
  final http.Client client;

  ApiClient(this.client);

  Future<Map<String, dynamic>> post(
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) async {
    try {
      print("1 from post");
      final response = await client
          .post(
            Uri.parse('${EndPoint.baseUrl}$endpoint'),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              ...?headers,
            },
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(const Duration(seconds: 30));
      print("2 from post");
      print("the body is ${response.body}");

      return _handleResponse(response);
    } on TimeoutException {
      throw const TimeoutException();
    } on ApiException {
      rethrow;
    } on http.ClientException {
      throw const NetworkException();
    } catch (e) {
      throw const UnknownApiException();
    }
  }

  Map<String, dynamic> _handleResponse(http.Response response) {
    dynamic decodedBody;

    try {
      if (response.body.isNotEmpty) {
        print("empty body from post");
        decodedBody = jsonDecode(response.body);
        print("3 from post after decoding the body");
      }
    } catch (_) {
      decodedBody = null;
    }

    // =========================================================
    // SUCCESS
    // =========================================================

    if (response.statusCode >= 200 && response.statusCode < 300) {
      print("4 from post is 200 code");
      if (decodedBody is Map<String, dynamic>) {
        return decodedBody;
      }

      throw const UnknownApiException(message: 'استجابة غير صالحة من الخادم.');
    }

    // =========================================================
    // ERROR
    // =========================================================

    final String message = _extractArabicMessage(
      decodedBody is Map<String, dynamic> ? decodedBody['message'] : null,
    );

    final Map<String, dynamic>? errors =
        decodedBody is Map<String, dynamic> &&
            decodedBody['errors'] is Map<String, dynamic>
        ? Map<String, dynamic>.from(decodedBody['errors'] as Map)
        : null;

    switch (response.statusCode) {
      case 400:
        throw ValidationException(
          message: message,
          statusCode: response.statusCode,
          errors: errors,
        );

      case 401:
        throw UnauthorizedException(message: message);

      case 403:
        throw ForbiddenException(message: message);

      case 404:
        throw NotFoundException(message: message);

      case 500:
      case 501:
      case 502:
      case 503:
      case 504:
        throw ServerException(
          message: message,
          statusCode: response.statusCode,
        );

      default:
        throw ApiException(
          message: message,
          statusCode: response.statusCode,
          errors: errors,
        );
    }
  }

  String _extractArabicMessage(dynamic value) {
    // =========================================================
    // Case 1:
    // message is already a Map
    // =========================================================

    if (value is Map<String, dynamic>) {
      final arabicMessage = value['ar'];

      if (arabicMessage is String && arabicMessage.trim().isNotEmpty) {
        return arabicMessage;
      }

      final englishMessage = value['en'];

      if (englishMessage is String && englishMessage.trim().isNotEmpty) {
        return englishMessage;
      }
    }

    // =========================================================
    // Case 2:
    // message is a JSON String
    // =========================================================

    if (value is String && value.trim().isNotEmpty) {
      try {
        final decoded = jsonDecode(value);

        if (decoded is Map<String, dynamic>) {
          final arabicMessage = decoded['ar'];

          if (arabicMessage is String && arabicMessage.trim().isNotEmpty) {
            return arabicMessage;
          }

          final englishMessage = decoded['en'];

          if (englishMessage is String && englishMessage.trim().isNotEmpty) {
            return englishMessage;
          }
        }
      } catch (_) {
        // إذا لم تكن الرسالة JSON
        // نرجع النص نفسه.
        return value;
      }

      return value;
    }

    return 'حدث خطأ أثناء تنفيذ الطلب.';
  }
}
