import 'dart:async';
import 'dart:convert';
import 'dart:io' show SocketException;

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../error/exceptions.dart';

/// Returns headers to attach to every request (e.g. authentication).
/// Left as a callback because the auth mechanism is defined by the backend.
typedef HeadersBuilder = Map<String, String> Function();

/// Centralised HTTP client. Data sources call this; nothing else touches `http`.
/// Returns the decoded JSON body (Map / List / String / null) or throws an
/// [AppException].
class ApiClient {
  ApiClient({
    required this.baseUrl,
    http.Client? client,
    this.authHeaders,
    this.timeout = const Duration(seconds: 30),
    this.enableLogging = kDebugMode,
  }) : _client = client ?? http.Client();

  final String baseUrl;
  final Duration timeout;
  final bool enableLogging;
  final HeadersBuilder? authHeaders;
  final http.Client _client;

  Future<dynamic> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) => _send('GET', path, queryParameters: queryParameters, headers: headers);

  Future<dynamic> post(
    String path, {
    Object? body,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) => _send(
    'POST',
    path,
    body: body,
    queryParameters: queryParameters,
    headers: headers,
  );

  Future<dynamic> put(
    String path, {
    Object? body,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) => _send(
    'PUT',
    path,
    body: body,
    queryParameters: queryParameters,
    headers: headers,
  );

  Future<dynamic> patch(
    String path, {
    Object? body,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) => _send(
    'PATCH',
    path,
    body: body,
    queryParameters: queryParameters,
    headers: headers,
  );

  Future<dynamic> delete(
    String path, {
    Object? body,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) => _send(
    'DELETE',
    path,
    body: body,
    queryParameters: queryParameters,
    headers: headers,
  );

  // ---------------------------------------------------------------------------

  Future<dynamic> _send(
    String method,
    String path, {
    Object? body,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) async {
    final uri = _buildUri(path, queryParameters);
    final request = http.Request(method, uri)
      ..headers.addAll({
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        ...?authHeaders?.call(),
        ...?headers,
      });
    if (body != null) request.body = jsonEncode(body);

    _log('--> $method $uri${body != null ? '\n    body: ${request.body}' : ''}');

    try {
      final streamed = await _client.send(request).timeout(timeout);
      final response = await http.Response.fromStream(streamed);
      _log(
        '<-- ${response.statusCode} $uri\n'
        '    ${_truncate(utf8.decode(response.bodyBytes, allowMalformed: true))}',
      );
      return _handleResponse(response);
    } on AppException {
      rethrow;
    } on TimeoutException {
      throw const RequestTimeoutException();
    } on SocketException {
      throw const NetworkException();
    } on http.ClientException {
      throw const NetworkException();
    } catch (e) {
      throw UnknownException(e.toString());
    }
  }

  Uri _buildUri(String path, Map<String, dynamic>? query) {
    if (baseUrl.isEmpty) {
      throw StateError(
        'API base URL is empty. Run with --dart-define=API_BASE_URL=<url>.',
      );
    }
    final base = baseUrl.endsWith('/')
        ? baseUrl.substring(0, baseUrl.length - 1)
        : baseUrl;
    final cleanPath = path.startsWith('/') ? path : '/$path';

    final params = <String, dynamic>{};
    query?.forEach((key, value) {
      if (value == null) return;
      params[key] = value is Iterable
          ? value.map((e) => e.toString()).toList()
          : value.toString();
    });

    final uri = Uri.parse('$base$cleanPath');
    return params.isEmpty ? uri : uri.replace(queryParameters: params);
  }

  dynamic _handleResponse(http.Response response) {
    final status = response.statusCode;
    final decoded = _decodeBody(response);

    if (status >= 200 && status < 300) return decoded;

    // Error body shape is not known yet: only pick a message if the backend
    // clearly sent a plain string under the conventional "message" key.
    final message = _extractMessage(decoded);

    switch (status) {
      case 401:
        throw UnauthorizedException(message);
      case 403:
        throw ForbiddenException(message);
      case 404:
        throw NotFoundException(message);
      case 400:
      case 422:
        throw ValidationException(message, decoded);
      default:
        throw ServerException(message, status);
    }
  }

  dynamic _decodeBody(http.Response response) {
    if (response.bodyBytes.isEmpty) return null;
    final text = utf8.decode(response.bodyBytes, allowMalformed: true);
    try {
      return jsonDecode(text);
    } on FormatException {
      return text;
    }
  }

  String? _extractMessage(dynamic body) {
    if (body is Map && body['message'] is String) {
      return body['message'] as String;
    }
    return null;
  }

  void _log(String message) {
    if (enableLogging) debugPrint('[ApiClient] $message');
  }

  String _truncate(String s, [int max = 1000]) =>
      s.length <= max ? s : '${s.substring(0, max)}…';

  void dispose() => _client.close();
}
