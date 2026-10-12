import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lottie/lottie.dart';

import '../api/apiKeys/store_keys.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({super.key});

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  @override
  void initState() {
    super.initState();
    _resolveAuthRoute();
  }

  /// Checks whether the user has a previously stored session (valid tokens)
  /// and navigates to the appropriate route once the loading animation ends.
  Future<void> _resolveAuthRoute() async {
    // Determine the destination while the loading animation is playing.
    final bool isLoggedIn = _hasValidSession();

    // Keep the splash visible for its intended duration before navigating.
    await Future.delayed(const Duration(seconds: 3));
    if (!mounted) return;

    if (isLoggedIn) {
      context.goNamed('mainNavBar');
    } else {
      context.goNamed('signInPage');
    }
  }

  /// Returns true when non-empty access & refresh tokens exist in storage.
  bool _hasValidSession() {
    final box = GetStorage();
    final String? accessToken = box.read<String>(StorageKeys.accessToken);
    final String? refreshToken = box.read<String>(StorageKeys.refreshToken);
    return accessToken != null &&
        accessToken.isNotEmpty &&
        refreshToken != null &&
        refreshToken.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('assets/img/bg.png', fit: BoxFit.cover),
          ),
          Center(
            child: Column(
              children: [
                SizedBox(height: height * 0.25),
                ZoomIn(
                  delay: Duration(milliseconds: 600),
                  child: Image.asset(
                    "assets/img/logo.png",
                    // height: height * 0.4,
                    width: width * 0.4,
                  ),
                ),
                // Lottie.asset(
                //   'assets/animations/logoAnim.json',
                //   width: width * 0.6,
                //   height: height * 0.6,
                // ),
                SizedBox(height: 10.h),
                ZoomIn(
                  delay: Duration(milliseconds: 700),
                  child: Text(
                    "تكنولوجيا, طاقة, حلول",
                    style: textTheme.headlineSmall,
                  ),
                ),
                SizedBox(height: 70.h),
                ZoomIn(
                  delay: Duration(milliseconds: 800),
                  child: CircularProgressIndicator(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
