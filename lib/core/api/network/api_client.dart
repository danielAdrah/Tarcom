import 'dart:async';
import 'dart:convert';

import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../apiKeys/end_point.dart';
import '../apiKeys/store_keys.dart';
import '../errors/api_excptions.dart';

class ApiClient {
  final http.Client client;

  /// مخزن الرموز (اختياري)؛ عند توفّره يتم حقن `Authorization: Bearer` تلقائياً
  /// للطلبات التي تحتاج توثيقاً دون الحاجة لتمرير الترويسة في كل مكان.
  final GetStorage? storage;

  ApiClient(this.client, {this.storage});

  // POST request
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
            headers: _buildHeaders(headers),
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

  //GET request
  Future<Map<String, dynamic>> get(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) async {
    try {
      final response = await client
          .get(
            _buildUri(endpoint, queryParameters),
            headers: _buildHeaders(headers),
          )
          .timeout(const Duration(seconds: 30));

      return _handleResponse(response);
    } on TimeoutException {
      throw const TimeoutException();
    } on ApiException {
      rethrow;
    } on http.ClientException {
      throw const NetworkException();
    } catch (_) {
      throw const UnknownApiException();
    }
  }

  //GET request whose payload is a plain JSON array (not paginated).
  Future<List<dynamic>> getList(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) async {
    try {
      final response = await client
          .get(
            _buildUri(endpoint, queryParameters),
            headers: _buildHeaders(headers),
          )
          .timeout(const Duration(seconds: 30));

      return _handleListResponse(response);
    } on TimeoutException {
      throw const TimeoutException();
    } on ApiException {
      rethrow;
    } on http.ClientException {
      throw const NetworkException();
    } catch (_) {
      throw const UnknownApiException();
    }
  }

  Uri _buildUri(String endpoint, Map<String, dynamic>? queryParameters) {
    final baseUri = Uri.parse('${EndPoint.baseUrl}$endpoint');

    if (queryParameters == null || queryParameters.isEmpty) {
      return baseUri;
    }

    return baseUri.replace(
      queryParameters: {
        ...baseUri.queryParameters,
        ...queryParameters.map(
          (key, value) => MapEntry(key, value?.toString() ?? ''),
        ),
      },
    );
  }

  Map<String, String> _buildHeaders(Map<String, String>? headers) {
    final String? accessToken = storage?.read<String>(StorageKeys.accessToken);

    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      // حقن رمز الحامل تلقائياً إن وُجد ولم يحدّده المستدعي صراحةً.
      if (accessToken != null && accessToken.isNotEmpty)
        'Authorization': 'Bearer $accessToken',
      ...?headers,
    };
  }

  Map<String, dynamic> _handleResponse(http.Response response) {
    final dynamic decodedBody = _decodeBody(response);

    // =========================================================
    // SUCCESS
    // =========================================================

    if (_isSuccess(response.statusCode)) {
      if (decodedBody is Map<String, dynamic>) {
        return decodedBody;
      }

      throw const UnknownApiException(message: 'استجابة غير صالحة من الخادم.');
    }

    // =========================================================
    // ERROR
    // =========================================================

    throw _mapError(response.statusCode, decodedBody);
  }

  List<dynamic> _handleListResponse(http.Response response) {
    final dynamic decodedBody = _decodeBody(response);

    if (_isSuccess(response.statusCode)) {
      if (decodedBody is List<dynamic>) {
        return decodedBody;
      }

      if (decodedBody is Map<String, dynamic> &&
          decodedBody['results'] is List<dynamic>) {
        return decodedBody['results'] as List<dynamic>;
      }

      throw const UnknownApiException(message: 'استجابة غير صالحة من الخادم.');
    }

    throw _mapError(response.statusCode, decodedBody);
  }

  dynamic _decodeBody(http.Response response) {
    if (response.body.isEmpty) {
      return null;
    }

    try {
      return jsonDecode(response.body);
    } catch (_) {
      return null;
    }
  }

  bool _isSuccess(int statusCode) => statusCode >= 200 && statusCode < 300;

  Never _mapError(int statusCode, dynamic decodedBody) {
    final String message = _extractArabicMessage(
      decodedBody is Map<String, dynamic> ? decodedBody['message'] : null,
    );

    final Map<String, dynamic>? errors =
        decodedBody is Map<String, dynamic> &&
            decodedBody['errors'] is Map<String, dynamic>
        ? Map<String, dynamic>.from(decodedBody['errors'] as Map)
        : null;

    switch (statusCode) {
      case 400:
        throw ValidationException(
          message: message,
          statusCode: statusCode,
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
        throw ServerException(message: message, statusCode: statusCode);

      default:
        throw ApiException(
          message: message,
          statusCode: statusCode,
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
