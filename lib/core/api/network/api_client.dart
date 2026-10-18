import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;

import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../apiKeys/end_point.dart';
import '../apiKeys/store_keys.dart';
import '../errors/api_excptions.dart';

/// يُرجع true إذا نجح تحديث رمز الوصول (وتم تخزينه)، وfalse إذا تعذّر ذلك
/// (رمز تحديث منتهي أو غير موجود) فتُنهى الجلسة قسراً.
typedef TokenRefreshCallback = Future<bool> Function();

/// يُستدعى عند فشل تحديث الرمز لإنهاء الجلسة محلياً وتوجيه المستخدم للدخول.
typedef AuthFailureCallback = void Function();

class ApiClient {
  final http.Client client;

  /// مخزن الرموز (اختياري)؛ عند توفّره يتم حقن `Authorization: Bearer` تلقائياً
  /// للطلبات التي تحتاج توثيقاً دون الحاجة لتمرير الترويسة في كل مكان.
  final GetStorage? storage;

  /// حقن عبر DI لكسر الاعتماد الدائري: ينفّذ منطق التحديث في طبقة الميزات
  /// دون أن تعتمد `core` على `features` مباشرة.
  TokenRefreshCallback? onTokenRefresh;
  AuthFailureCallback? onAuthFailure;

  /// يمنع إعادة محاولة التحديث داخل طلب التحديث نفسه (تجنّب التفاف لا نهائي).
  bool _isRefreshing = false;

  /// مستقبَل مشترك ليَنتظره جميع الطلبات المتزامنة التي تواجه 401 في المرة
  /// نفسها، بحيث يُنفَّذ تحديث واحد فقط بدل عدّة تحديثات متكرّرة.
  Future<bool>? _refreshFuture;

  ApiClient(this.client, {this.storage});

  /// ينفّذ الطلب، ويعيد محاولة واحدة تلقائياً بعد تحديث رمز الوصول عند 401.
  /// إن فشل التحديث، يُنهى الجلسة عبر [onAuthFailure] ثم يُرمى استثناء 401.
  Future<T> _execute<T>({
    required String endpoint,
    required String logLabel,
    required Future<http.Response> Function() send,
    required T Function(http.Response) handle,
  }) async {
    try {
      developer.log('$logLabel -> $endpoint', name: 'ApiClient');
      var response = await send().timeout(const Duration(seconds: 30));
      developer.log(
        '$logLabel <- ${response.statusCode} ${response.body}',
        name: 'ApiClient',
      );

      // اعتراض 401: حدّث رمز الوصول مرة واحدة ثم أعد الطلب الأصلي بهيدر جديد.
      if (response.statusCode == 401 &&
          !_isRefreshing &&
          onTokenRefresh != null) {
        final bool refreshed = await _refreshTokenOnce();
        if (refreshed) {
          // تُعاد تهيئة الترويسات داخل send() فيُقرأ رمز الوصول الجديد.
          response = await send().timeout(const Duration(seconds: 30));
          developer.log(
            '$logLabel RETRY <- ${response.statusCode} ${response.body}',
            name: 'ApiClient',
          );
        } else {
          onAuthFailure?.call();
        }
      }

      return handle(response);
    } on TimeoutException {
      developer.log('$logLabel timeout: $endpoint', name: 'ApiClient');
      throw const TimeoutException();
    } on ApiException catch (e) {
      developer.log(
        '$logLabel ApiException: $endpoint -> $e',
        name: 'ApiClient',
        error: e,
      );
      rethrow;
    } on http.ClientException catch (e, s) {
      developer.log(
        '$logLabel ClientException: $endpoint',
        name: 'ApiClient',
        error: e,
        stackTrace: s,
      );
      throw const NetworkException();
    } catch (e, s) {
      developer.log(
        '$logLabel UNEXPECTED: $endpoint [${e.runtimeType}]',
        name: 'ApiClient',
        error: e,
        stackTrace: s,
      );
      throw UnknownApiException(
        message: 'حدث خطأ غير متوقع. [${e.runtimeType}]',
      );
    }
  }

  /// يشغّل [onTokenRefresh] مرة واحدة فقط ويشارك النتيجة مع كل النداءات
  /// المتزامنة. يعيد false عند فشل التحديث أو عدم توفّر نافذة تحديث.
  Future<bool> _refreshTokenOnce() {
    return _refreshFuture ??= () async {
      _isRefreshing = true;
      try {
        return await onTokenRefresh!.call();
      } catch (e, s) {
        developer.log(
          'token refresh failed',
          name: 'ApiClient',
          error: e,
          stackTrace: s,
        );
        return false;
      } finally {
        _isRefreshing = false;
        _refreshFuture = null;
      }
    }();
  }

  // POST request
  Future<Map<String, dynamic>> post(
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) {
    return _execute(
      endpoint: endpoint,
      logLabel: 'POST',
      send: () => client.post(
        Uri.parse('${EndPoint.baseUrl}$endpoint'),
        headers: _buildHeaders(headers),
        body: body != null ? jsonEncode(body) : null,
      ),
      handle: _handleResponse,
    );
  }

  // PUT request (تحديث كامل - full update)
  Future<Map<String, dynamic>> put(
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) {
    return _execute(
      endpoint: endpoint,
      logLabel: 'PUT',
      send: () => client.put(
        Uri.parse('${EndPoint.baseUrl}$endpoint'),
        headers: _buildHeaders(headers),
        body: body != null ? jsonEncode(body) : null,
      ),
      handle: _handleResponse,
    );
  }

  //GET request
  Future<Map<String, dynamic>> get(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) {
    return _execute(
      endpoint: endpoint,
      logLabel: 'GET',
      send: () => client.get(
        _buildUri(endpoint, queryParameters),
        headers: _buildHeaders(headers),
      ),
      handle: _handleResponse,
    );
  }

  //GET request whose payload is a plain JSON array (not paginated).
  Future<List<dynamic>> getList(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) {
    return _execute(
      endpoint: endpoint,
      logLabel: 'GETLIST',
      send: () => client.get(
        _buildUri(endpoint, queryParameters),
        headers: _buildHeaders(headers),
      ),
      handle: _handleListResponse,
    );
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
