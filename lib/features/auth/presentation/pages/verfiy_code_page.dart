import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/routes/route_imports.dart';

class VerfiyCodePage extends StatefulWidget {
  const VerfiyCodePage({super.key, required this.email});
  final String email;

  @override
  State<VerfiyCodePage> createState() => _VerfiyCodePageState();
}

class _VerfiyCodePageState extends State<VerfiyCodePage> {
  final codeTextField = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
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
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: ElevatedButton(
                        onPressed: () {
                          context.goNamed('mainNavBar');
                          // Handle verification logic here
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
      ),
    );
  }
}
