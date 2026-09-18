import 'package:animate_do/animate_do.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/common/app_background.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final textTheme = Theme.of(context).textTheme;
    return AppBackground(
      child: SafeArea(
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              20.r,
              0,
              20.r,
              MediaQuery.viewInsetsOf(context).bottom + 50.h,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 50.h),
                FadeInUp(
                  delay: Duration(milliseconds: 400),
                  child: Center(
                    child: Image.asset(
                      "assets/img/logo.png",
                      // height: height * 0.4,
                      width: width * 0.3,
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                FadeInUp(
                  delay: Duration(milliseconds: 500),
                  child: Text('إنشاء حساب', style: textTheme.displaySmall),
                ),
                SizedBox(height: 5.h),
                FadeInUp(
                  delay: Duration(milliseconds: 600),
                  child: Text(
                    "انضم ل تاركوم و اكتشف أفضل المنتجات",
                    style: textTheme.bodyMedium,
                  ),
                ),
                SizedBox(height: 30.h),
                FadeInUp(
                  delay: Duration(milliseconds: 700),
                  child: Text(
                    "الاسم الكامل",
                    style: textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                SizedBox(height: 5.h),
                FadeInUp(
                  delay: Duration(milliseconds: 800),
                  child: Material(
                    child: TextField(
                      controller: fullNameController,
                      decoration: InputDecoration(
                        hintText: 'أدخل الاسم الكامل',
                        prefixIcon: Icon(Icons.person),
                        // fillColor: AppColors.surface.withOpacity(0.8),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                FadeInUp(
                  delay: Duration(milliseconds: 900),
                  child: Text(
                    "البريد الإلكتروني",
                    style: textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                SizedBox(height: 5.h),
                FadeInUp(
                  delay: Duration(milliseconds: 1000),
                  child: Material(
                    child: TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        hintText: 'أدخل البريد الإلكتروني',
                        prefixIcon: Icon(Icons.email),
                        // fillColor: AppColors.surface.withOpacity(0.8),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                FadeInUp(
                  delay: Duration(milliseconds: 1100),
                  child: Text(
                    "كلمة المرور",
                    style: textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                SizedBox(height: 5.h),
                FadeInUp(
                  delay: Duration(milliseconds: 1200),
                  child: Material(
                    child: TextField(
                      controller: passwordController,
                      decoration: InputDecoration(
                        hintText: 'أدخل كلمة المرور',
                        prefixIcon: Icon(Icons.lock),
                        // fillColor: AppColors.surface.withOpacity(0.8),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                FadeInUp(
                  delay: Duration(milliseconds: 1300),
                  child: Text(
                    "تأكيد كلمة المرور",
                    style: textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                SizedBox(height: 5.h),
                FadeInUp(
                  delay: Duration(milliseconds: 1400),
                  child: Material(
                    child: TextField(
                      controller: confirmPasswordController,
                      decoration: InputDecoration(
                        hintText: 'أدخل تأكيد كلمة المرور',
                        prefixIcon: Icon(Icons.lock),
                        // fillColor: AppColors.surface.withOpacity(0.8),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                FadeInUp(
                  delay: Duration(milliseconds: 1500),
                  child: ElevatedButton(
                    onPressed: () {
                      context.pushNamed('mainNavBar');
                    },
                    child: Text('إنشاء حساب'),
                  ),
                ),
                SizedBox(height: 5.h),
                FadeInUp(
                  delay: Duration(milliseconds: 1600),
                  child: Center(
                    child: Text.rich(
                      TextSpan(
                        text: 'هل لديك حساب؟ ',
                        style: textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).primaryColor,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: 'تسجيل الدخول',
                            style: textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context).colorScheme.secondary,
                              fontWeight: FontWeight.bold,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                context.goNamed('signInPage');
                              },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 50.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
