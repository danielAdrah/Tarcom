import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/colors.dart';
import '../pages/home_page.dart';

class FeaturedProCard extends StatelessWidget {
  FeaturedProCard({
    super.key,
    required this.category,
    required this.textTheme,
    required this.onTap,
  });

  final CategoryItem category;
  final TextTheme textTheme;
  void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.only(bottom: 5.r),
        // height: 150.h,
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
          color: AppColors.surface,
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.r),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Image.asset(
                  category.img,
                  width: 150.w,
                  height: 150.h,
                  fit: BoxFit.fill,
                ),
              ),
              // SizedBox(height: 5.h),
              Text(
                category.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: textTheme.titleSmall?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.end,
              ),
              Text(
                category.briefDesc,
                // overflow: TextOverflow.ellipsis,
                // textDirection: TextDirection.rtl,
                style: textTheme.labelSmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.end,
              ),
              Text(
                '${category.price}Sp',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: textTheme.titleSmall?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
                // textAlign: TextAlign.end,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
