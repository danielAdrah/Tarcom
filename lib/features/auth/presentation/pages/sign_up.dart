import 'package:animate_do/animate_do.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/common/app_background.dart';
import '../../../../core/common/custom_indecator.dart';
import '../../../../core/constants/colors.dart';
// import '../../../profile/presentation/widgets/profile_edit_field.dart';
import '../bloc/sign_up.dart/bloc/sign_up_bloc.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController numberController = TextEditingController();

  /// رمز الدولة السوري الثابت كبادئة غير قابلة للتحرير أمام حقل الهاتف.
  static const String _phonePrefix = '+963';

  /// التحقق من الجزء المحلي فقط: 9 أرقام بعد البادئة `_phonePrefix`.
  static final RegExp _localPhoneRegex = RegExp(r'^\d{9}$');

  /// كلمة المرور: 8 أحرف على الأقل وتحتوي على أرقام وحروف معاً.
  static final RegExp _passwordRegex = RegExp(r'^(?=.*[A-Za-z])(?=.*\d).{8,}$');

  bool _isValidPassword(String password) => _passwordRegex.hasMatch(password);

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    numberController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  void clearFields() {
    firstNameController.clear();
    lastNameController.clear();
    emailController.clear();
    numberController.clear();
    passwordController.clear();
  }

  String? _validatePhone(String? value) {
    final String trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) return 'رقم الهاتف مطلوب';
    if (!_localPhoneRegex.hasMatch(trimmed)) {
      return 'يجب أن يكون الرقم 9 أرقام (مثال: 991234567)';
    }
    return null;
  }

  void _submitSignUp() {
    context.read<SignUpBloc>().add(
      SignUpSubmitted(
        email: emailController.text.trim(),
        password: passwordController.text,
        firstName: firstNameController.text.trim(),
        lastName: lastNameController.text.trim(),
        // نجمع البادئة الثابتة مع الإدخال المحلي لإرسال الرقم الدولي الكامل.
        phone: '$_phonePrefix${numberController.text.trim()}',
        userType: 'customer',
      ),
    );
    clearFields();
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final textTheme = Theme.of(context).textTheme;
    return AppBackground(
      child: BlocConsumer<SignUpBloc, SignUpState>(
        listener: (context, state) {
          // =====================================================
          // SUCCESS
          // =====================================================

          if (state is SignUpSuccess) {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.response.message),
                behavior: SnackBarBehavior.floating,
                duration: const Duration(seconds: 3),
                backgroundColor: AppColors.success,
              ),
            );

            context.pushNamed('verfiyCodePage', extra: state.email);
          }

          // =====================================================
          // FAILURE
          // =====================================================

          if (state is SignUpFailure) {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                behavior: SnackBarBehavior.floating,
                duration: const Duration(seconds: 4),
                backgroundColor: AppColors.error,
              ),
            );
          }
        },

        builder: (context, state) {
          return Scaffold(
            backgroundColor: Colors.transparent,
            body: SafeArea(
              child: SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
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
                        child: Text(
                          'إنشاء حساب',
                          style: textTheme.displaySmall,
                        ),
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
                          "الاسم الأول",
                          style: textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      SizedBox(height: 5.h),
                      FadeInUp(
                        delay: Duration(milliseconds: 800),
                        child: Material(
                          borderRadius: BorderRadius.circular(12.r),
                          child: TextField(
                            controller: firstNameController,
                            keyboardType: TextInputType.name,
                            decoration: InputDecoration(
                              hintText: 'أدخل الاسم الأول',
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
                          "الأسم الأخير",
                          style: textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      SizedBox(height: 5.h),
                      FadeInUp(
                        delay: Duration(milliseconds: 1000),
                        child: Material(
                          borderRadius: BorderRadius.circular(12.r),
                          child: TextField(
                            controller: lastNameController,
                            keyboardType: TextInputType.name,
                            decoration: InputDecoration(
                              hintText: 'أدخل الاسم الأخير',
                              prefixIcon: Icon(Icons.person),
                              // fillColor: AppColors.surface.withOpacity(0.8),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20.h),
                      FadeInUp(
                        delay: Duration(milliseconds: 1100),
                        child: Text(
                          "البريد الإلكتروني",
                          style: textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      SizedBox(height: 5.h),
                      FadeInUp(
                        delay: Duration(milliseconds: 1200),
                        child: Material(
                          borderRadius: BorderRadius.circular(12.r),
                          child: TextField(
                            controller: emailController,
                            keyboardType: TextInputType.emailAddress,
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
                        delay: Duration(milliseconds: 1300),
                        child: Text(
                          "رقم الهاتف",
                          style: textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      SizedBox(height: 5.h),
                      FadeInUp(
                        delay: Duration(milliseconds: 1400),
                        child: Material(
                          borderRadius: BorderRadius.circular(12.r),
                          child: TextField(
                            controller: numberController,
                            // maxLength: 9,
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                              hintText: 'أدخل رقم الهاتف',
                              prefixIcon: Icon(Icons.phone),
                              // fillColor: AppColors.surface.withOpacity(0.8),
                            ),
                          ),
                        ),
                      ),

                      // FadeInUp(
                      //   delay: Duration(milliseconds: 1400),
                      //   child: Material(
                      //     borderRadius: BorderRadius.circular(12.r),
                      //     // نغلّف الحقل بـ LTR مثل ProfileEditField في صفحة الملف الشخصي
                      //     // حتى يظهر البادئة الثابتة «+963» على اليسار بشكل صحيح.
                      //     child: ProfileEditField(
                      //       icon: Icons.phone_enabled,
                      //       label: 'رقم الهاتف',
                      //       controller: numberController,
                      //       prefixText: '$_phonePrefix ',
                      //       keyboardType: TextInputType.number,
                      //       maxLength: 9,
                      //       hintText: '',
                      //       inputFormatters: [
                      //         FilteringTextInputFormatter.digitsOnly,
                      //         LengthLimitingTextInputFormatter(9),
                      //       ],
                      //       validator: _validatePhone,
                      //     ),
                      //   ),
                      // ),
                      SizedBox(height: 20.h),
                      FadeInUp(
                        delay: Duration(milliseconds: 1300),
                        child: Text(
                          "كلمة المرور",
                          style: textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      SizedBox(height: 5.h),
                      FadeInUp(
                        delay: Duration(milliseconds: 1400),
                        child: Material(
                          borderRadius: BorderRadius.circular(12.r),
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
                      state is SignUpLoading
                          ? Center(child: CustomIndecator(size: 30.w))
                          : FadeInUp(
                              delay: Duration(milliseconds: 1500),
                              child: ElevatedButton(
                                onPressed: () {
                                  if (firstNameController.text.trim().isEmpty ||
                                      lastNameController.text.trim().isEmpty ||
                                      emailController.text.trim().isEmpty ||
                                      passwordController.text.isEmpty ||
                                      numberController.text.trim().isEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'يرجى ملء جميع الحقول قبل المتابعة.',
                                        ),
                                        behavior: SnackBarBehavior.floating,
                                        duration: const Duration(seconds: 4),
                                        backgroundColor: AppColors.error,
                                      ),
                                    );
                                    return;
                                  } else if (!_localPhoneRegex.hasMatch(
                                    numberController.text.trim(),
                                  )) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'يجب أن يكون رقم الهاتف 9 أرقام (مثال: 991234567).',
                                        ),
                                        behavior: SnackBarBehavior.floating,
                                        duration: const Duration(seconds: 4),
                                        backgroundColor: AppColors.error,
                                      ),
                                    );
                                    return;
                                  } else if (!_isValidPassword(
                                    passwordController.text,
                                  )) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'يجب أن تحتوي كلمة المرور على 8 أحرف على الأقل وتضم أرقاماً وحروفاً معاً.',
                                        ),
                                        behavior: SnackBarBehavior.floating,
                                        duration: const Duration(seconds: 4),
                                        backgroundColor: AppColors.error,
                                      ),
                                    );
                                    return;
                                  } else {
                                    _submitSignUp();
                                  }
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
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.secondary,
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
        },
      ),
    );
  }
}
