import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/constants/colors.dart';

/// Skeleton mirror of CompanyCell: separate shimmer blocks for the company
/// logo, name, subtitle, and chevron so the loading state matches the real
/// cell 1:1. Block opacity encodes visual hierarchy.
class CompanyShimmerCell extends StatelessWidget {
  const CompanyShimmerCell({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(12.w, 12.h, 12.w, 10.h),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.06),
            blurRadius: 12.r,
            offset: Offset(0, 5.h),
          ),
        ],
      ),
      child: Shimmer.fromColors(
        baseColor: AppColors.skeletonBase,
        highlightColor: AppColors.skeletonHighlight,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Centered company logo area
            Expanded(
              child: Center(
                child: _block(
                  height: 110.h,
                  width: 110.w,
                  radius: 12.r,
                  alpha: 1.0,
                ),
              ),
            ),
            SizedBox(height: 10.h),
            Row(
              textDirection: TextDirection.rtl,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Company name (single bold line)
                      _block(
                        height: 14.h,
                        width: 90.w,
                        radius: 7.r,
                        alpha: 0.9,
                      ),
                      SizedBox(height: 4.h),
                      // "استكشف المنتجات" subtitle line
                      _block(height: 10.h, width: 65.w, alpha: 0.5),
                    ],
                  ),
                ),
                // Chevron button placeholder
                _block(height: 30.w, width: 30.w, radius: 30.w, alpha: 0.55),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// A single skeleton block. The shimmer shader tints opaque pixels, so the
  /// block's alpha controls how strongly it participates in the effect.
  Widget _block({
    double? height,
    double? width,
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
