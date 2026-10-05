/// Central API configuration.
///
/// The base URL is intentionally NOT hard-coded: it is provided at build time
///   flutter run --dart-define=API_BASE_URL=https://example.com
/// Endpoint paths are added per feature when the API contract is known.
abstract final class ApiConfig {
  static const String baseUrl = String.fromEnvironment('API_BASE_URL');

  static const Duration timeout = Duration(seconds: 30);
}
