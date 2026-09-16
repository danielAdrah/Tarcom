import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({super.key});

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      context.goNamed('signInPage');
    });
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
