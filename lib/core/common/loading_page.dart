import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';

import '../di/injection_container.dart';
import '../services/auth_route_resolver.dart';
import '../services/connectivity_service.dart';

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

  /// Once the loading animation ends, verifies connectivity and then either
  /// resumes the authentication flow (online) or interrupts it with the
  /// "No Internet Connection" screen (offline).
  Future<void> _resolveAuthRoute() async {
    // Keep the splash visible for its intended duration before navigating.
    await Future.delayed(const Duration(seconds: 3));
    if (!mounted) return;

    final bool isOnline = await sl<ConnectivityService>().isOnline();
    if (!mounted) return;

    if (isOnline) {
      AuthRouteResolver.goNext(context);
    } else {
      context.goNamed('noInternetPage');
    }
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
                SizedBox(height: 50.h),
                ZoomIn(
                  delay: Duration(milliseconds: 800),
                  child: SpinKitChasingDots(
                    color: Theme.of(context).primaryColor,
                    size: 50.w,
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
