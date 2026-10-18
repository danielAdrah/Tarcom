import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;

/// Checks whether the device has a usable internet connection.
///
/// Combines two signals:
/// 1. [Connectivity] interface status (fast, no network I/O) — detects
///    airplane mode / no Wi-Fi or mobile data at all.
/// 2. A lightweight reachability probe — catches the "connected to a network
///    but no internet" case (e.g. captive portal, router without upstream).
class ConnectivityService {
  ConnectivityService(this._client);

  final http.Client _client;

  /// Google's generate_204 endpoint: responds with HTTP 204 and no body,
  /// so any reply at all proves real internet reachability.
  static final Uri _reachabilityUri = Uri.parse(
    'https://clients3.google.com/generate_204',
  );

  static const Duration _probeTimeout = Duration(seconds: 3);

  /// Returns true only when a network interface is attached
  /// AND the reachability probe succeeds.
  Future<bool> isOnline() async {
    final List<ConnectivityResult> results = await Connectivity()
        .checkConnectivity();
    if (results.contains(ConnectivityResult.none)) return false;
    return _hasInternetAccess();
  }

  /// Emits whenever the device's connectivity interfaces change.
  /// Used by the "No Internet" screen to resume the flow automatically.
  Stream<List<ConnectivityResult>> get onConnectivityChanged =>
      Connectivity().onConnectivityChanged;

  Future<bool> _hasInternetAccess() async {
    try {
      await _client.head(_reachabilityUri).timeout(_probeTimeout);
      return true;
    } catch (_) {
      // Timeout or transport error → no usable internet.
      return false;
    }
  }
}
