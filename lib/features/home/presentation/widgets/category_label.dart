import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/colors.dart';

class CategoryLabel extends StatelessWidget {
  CategoryLabel({
    super.key,
    required this.label,
    required this.img,
    required this.onTap,
  });

  final String label;
  final String img;
  void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.all(10.r),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: AppColors.border),
              color: AppColors.blue50,
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
            ),

            child: Center(
              child: Image.asset(
                img,
                width: 30.w,
                height: 30.h,
                color: AppColors.primary,
              ),
            ),
          ),
        ),
        Text(
          label,
          style: textTheme.labelSmall?.copyWith(color: AppColors.primary),
        ),
      ],
    );
  }
}
