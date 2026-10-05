import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/colors.dart';

class ContactusPage extends StatefulWidget {
  const ContactusPage({super.key});

  @override
  State<ContactusPage> createState() => _ContactusPageState();
}

class _ContactusPageState extends State<ContactusPage> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: SafeArea(
        child: FadeInUp(
          delay: Duration(milliseconds: 400),
          child: CustomScrollView(
            physics: BouncingScrollPhysics(),
            slivers: [
              SliverAppBar(
                automaticallyImplyLeading: false,
                backgroundColor: AppColors.background,
                surfaceTintColor: Colors.transparent,
                elevation: 0,
                toolbarHeight: 72.h,
                title: Text(
                  'تواصل معنا',
                  style: textTheme.titleLarge?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                centerTitle: true,
              ),

              //banner section
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(8.r, 10.h, 8.r, 20.h),
                  child: Container(
                    height: 220.h,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.12),
                          blurRadius: 18.r,
                          offset: Offset(0, 7.h),
                        ),
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 4.r,
                          offset: Offset(0, 2.h),
                        ),
                      ],
                      borderRadius: BorderRadius.circular(15.r),
                      image: const DecorationImage(
                        image: AssetImage('assets/img/contactusbanner.png'),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
              ),

              //contactUs numbers section
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      headerTitle(textTheme, 'تواصل مباشرة'),
                      SizedBox(height: 10.h),
                      NumbersTile(textTheme: textTheme),
                      SizedBox(height: 10.h),
                      headerTitle(textTheme, 'موقعنا'),
                      SizedBox(height: 10.h),
                      LocationTile(textTheme: textTheme),
                      SizedBox(height: 10.h),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Row headerTitle(TextTheme textTheme, String title) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          height: 2.h,
          width: 16.w,
          decoration: BoxDecoration(
            color: AppColors.secondary,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        SizedBox(width: 5.w),
        Text(title, style: textTheme.titleMedium),
      ],
    );
  }
}

class LocationTile extends StatelessWidget {
  const LocationTile({super.key, required this.textTheme});

  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 10.w),
      decoration: BoxDecoration(
        color: AppColors.surface.withOpacity(0.3),
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        children: [
          //location image
          Container(
            height: 100.h,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.r),
            ),
            child: Image.asset('assets/img/location.jpg', fit: BoxFit.cover),
          ),
          SizedBox(height: 5.h),
          Row(
            children: [
              //location icon
              Container(
                padding: EdgeInsets.all(10.r),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 202, 219, 235),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Center(
                  child: Icon(
                    Icons.location_on,
                    size: 30.h,
                    color: AppColors.primary,
                  ),
                ),
              ),
              SizedBox(width: 10.w),
              //numbers section
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'شركة تاركوم',
                    style: textTheme.bodyMedium?.copyWith(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text('طرطوس شارع الثورة', style: textTheme.bodySmall),
                  Text('جانب فرنسا بنك', style: textTheme.bodySmall),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class NumbersTile extends StatelessWidget {
  const NumbersTile({super.key, required this.textTheme});

  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 10.w),
      decoration: BoxDecoration(
        color: AppColors.surface.withOpacity(0.3),
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              //phone icon
              Container(
                padding: EdgeInsets.all(10.r),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 202, 219, 235),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Center(
                  child: Icon(
                    Icons.phone_enabled,
                    size: 30.h,
                    color: AppColors.primary,
                  ),
                ),
              ),
              SizedBox(width: 10.w),
              //numbers section
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'اتصل بنا',
                    style: textTheme.bodyMedium?.copyWith(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text('أرقام الشركة', style: textTheme.bodySmall),
                  SizedBox(height: 6.h),
                  Text('0955321184', style: textTheme.bodySmall),
                  Text('0955321184', style: textTheme.bodySmall),
                ],
              ),
            ],
          ),

          //arrow
          Container(
            padding: EdgeInsets.all(3.r),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 202, 219, 235),
              borderRadius: BorderRadius.circular(15.r),
            ),
            child: Center(
              child: Icon(
                Icons.keyboard_arrow_left_outlined,
                size: 25.h,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
