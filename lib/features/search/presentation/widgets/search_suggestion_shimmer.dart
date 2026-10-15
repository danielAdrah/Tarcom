import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/constants/colors.dart';

/// Skeleton لصفحة مرشّحات البحث: كل عنصر (الصورة، السطر الأول، السطر الثاني)
/// له بلوك shimmer مستقل وفق الاتفاقية المعتمدة، مع تدرّج الشفافية بالأهمية.
class SearchSuggestionShimmer extends StatelessWidget {
  const SearchSuggestionShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      child: Shimmer.fromColors(
        baseColor: AppColors.skeletonBase,
        highlightColor: AppColors.skeletonHighlight,
        child: Row(
          textDirection: TextDirection.rtl,
          children: [
            // Image block
            _block(height: 40.r, width: 40.r, radius: 10.r, alpha: 1.0),
            SizedBox(width: 12.w),
            // Text lines
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _block(height: 12.h, width: 150.w, radius: 6.r, alpha: 0.9),
                  SizedBox(height: 6.h),
                  _block(height: 10.h, width: 90.w, radius: 5.r, alpha: 0.5),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _block({
    required double height,
    required double width,
    double? radius,
    required double alpha,
  }) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: alpha),
        borderRadius: BorderRadius.circular(radius ?? 5.r),
      ),
    );
  }
}
