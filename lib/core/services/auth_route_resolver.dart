import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:get_storage/get_storage.dart';

import '../api/apiKeys/store_keys.dart';

/// Shared post-splash navigation logic.
///
/// Used by both [LoadingPage] and [NoInternetPage] so the authentication
/// destination is always resolved the same way once the user is online.
class AuthRouteResolver {
  AuthRouteResolver._();

  /// Returns true when non-empty access & refresh tokens exist in storage.
  static bool hasValidSession() {
    final box = GetStorage();
    final String? accessToken = box.read<String>(StorageKeys.accessToken);
    final String? refreshToken = box.read<String>(StorageKeys.refreshToken);
    return accessToken != null &&
        accessToken.isNotEmpty &&
        refreshToken != null &&
        refreshToken.isNotEmpty;
  }

  /// Navigates to the signed-in flow or sign-in page based on stored tokens.
  /// Assumes connectivity has already been verified.
  static void goNext(BuildContext context) {
    if (!context.mounted) return;
    context.goNamed(hasValidSession() ? 'homePage' : 'signInPage');
  }
}
