import 'dart:async';

import 'package:animate_do/animate_do.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/colors.dart';
import '../di/injection_container.dart';
import '../services/auth_route_resolver.dart';
import '../services/connectivity_service.dart';

/// Shown when the splash screen detects that the device has no usable
/// internet connection. Interrupts the auth flow and either resumes it
/// automatically once connectivity is restored, or via the manual retry
/// button.
class NoInternetPage extends StatefulWidget {
  const NoInternetPage({super.key});

  @override
  State<NoInternetPage> createState() => _NoInternetPageState();
}

class _NoInternetPageState extends State<NoInternetPage> {
  StreamSubscription<List<ConnectivityResult>>? _connectivitySub;
  bool _isChecking = false;

  @override
  void initState() {
    super.initState();
    // Resume the flow automatically when an interface comes back.
    // The full online check (interface + reachability probe) still runs
    // inside _retry to cover "connected but no internet" cases.
    _connectivitySub = sl<ConnectivityService>().onConnectivityChanged.listen((
      List<ConnectivityResult> results,
    ) {
      if (!results.contains(ConnectivityResult.none)) {
        _retry();
      }
    });
  }

  @override
  void dispose() {
    _connectivitySub?.cancel();
    super.dispose();
  }

  /// Re-checks connectivity; when online, resumes the auth flow
  /// (sign-in or mainNavBar depending on stored tokens).
  Future<void> _retry() async {
    // Guard against concurrent probes from stream bursts or rapid taps.
    if (_isChecking) return;
    setState(() => _isChecking = true);

    final bool isOnline = await sl<ConnectivityService>().isOnline();
    if (!mounted) return;

    setState(() => _isChecking = false);
    if (isOnline) {
      AuthRouteResolver.goNext(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('assets/img/bg.png', fit: BoxFit.cover),
          ),
          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 32.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FadeInDown(
                    child: Container(
                      width: 110.w,
                      height: 110.w,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.08),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.wifi_off_rounded,
                        size: 56.w,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  SizedBox(height: 24.h),
                  FadeInDown(
                    delay: const Duration(milliseconds: 150),
                    child: Text(
                      "لا يوجد اتصال بالإنترنت",
                      style: textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.blue900,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  FadeInDown(
                    delay: const Duration(milliseconds: 250),
                    child: Text(
                      "يرجى التحقق من اتصالك بالشبكة ثم المحاولة مرة أخرى",
                      style: textTheme.bodyMedium?.copyWith(
                        color: Colors.black54,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 32.h),
                  FadeInDown(
                    delay: const Duration(milliseconds: 350),
                    child: SizedBox(
                      width: 200.w,
                      height: 48.h,
                      child: FilledButton.icon(
                        onPressed: _isChecking ? null : _retry,
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14.r),
                          ),
                        ),
                        icon: _isChecking
                            ? SizedBox(
                                width: 20.w,
                                height: 20.w,
                                child: const CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  color: Colors.white,
                                ),
                              )
                            : const Icon(Icons.refresh_rounded),
                        label: Text(
                          _isChecking ? "جارٍ التحقق..." : "إعادة المحاولة",
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
