import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tarcom/core/constants/colors.dart';

import '../../../../core/common/custom_indecator.dart';
import '../../../../core/routes/route_imports.dart';
import '../bloc/verify_otp/bloc/verify_otp_bloc.dart';

class VerfiyCodePage extends StatefulWidget {
  const VerfiyCodePage({super.key, required this.email});
  final String email;

  @override
  State<VerfiyCodePage> createState() => _VerfiyCodePageState();
}

class _VerfiyCodePageState extends State<VerfiyCodePage> {
  final codeTextField = TextEditingController();

  @override
  void dispose() {
    codeTextField.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<VerifyOtpBloc, VerifyOtpState>(
        listener: (context, state) {
          if (state is VerifyOtpSuccess) {
            print('Verification successful: ${state.response}');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'تم التحقق بنجاح ,أهلا و سهلا بك في تطبيق تاركوم',
                ),
                behavior: SnackBarBehavior.floating,
                duration: const Duration(seconds: 3),
                backgroundColor: AppColors.success,
              ),
            );
            context.goNamed('mainNavBar');
          }
          if (state is VerifyOtpFailure) {
            print('Verification failed: ${state.message}');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('فشل التحقق: ${state.message}'),
                behavior: SnackBarBehavior.floating,
                duration: const Duration(seconds: 3),
                backgroundColor: AppColors.error,
              ),
            );
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: FadeInUp(
              delay: Duration(milliseconds: 400),
              child: CustomScrollView(
                slivers: [
                  //image and title
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        SizedBox(height: 50.h),
                        Image.asset(
                          'assets/img/verfiy.png',
                          width: 300.w,
                          // height: 250.h,
                          fit: BoxFit.cover,
                        ),
                        // SizedBox(height: 20.h),
                        Text(
                          'التحقق من البريد الإلكتروني',
                          style: Theme.of(context).textTheme.headlineLarge,
                        ),
                      ],
                    ),
                  ),

                  //clearfication and textfield
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        SizedBox(height: 20.h),
                        Text(
                          'رجاء إدخال رمز التحقق المرسل إلى بريدك الإلكتروني.',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 20),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: TextField(
                            controller: codeTextField,

                            decoration: InputDecoration(
                              labelText: 'رمز التحقق',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        const SizedBox(height: 20),
                        state is VerifyOtpLoading
                            ? Center(child: CustomIndecator(size: 30.w))
                            : Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20.w),
                                child: ElevatedButton(
                                  onPressed: () {
                                    print('${int.parse(codeTextField.text)}');
                                    print(widget.email);
                                    context.read<VerifyOtpBloc>().add(
                                      VerifyOtpSubmitted(
                                        email: widget.email,
                                        code: int.parse(codeTextField.text),
                                        codeType: "SIGNUP",
                                      ),
                                    );
                                  },
                                  child: const Text('تحقق'),
                                ),
                              ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
