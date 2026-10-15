import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/constants/colors.dart';

/// Skeleton mirror of FeaturedProCard: each element (image, feature badge,
/// title, description lines, price capsule, company name) gets its own
/// shimmer block so the loading state matches the real card's layout 1:1.
/// Block opacity encodes visual hierarchy: primary surfaces are stronger,
/// secondary text blocks are fainter.
class FeaturedProductShimmerCard extends StatelessWidget {
  const FeaturedProductShimmerCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.08),
            blurRadius: 12.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18.r),
        child: Shimmer.fromColors(
          baseColor: AppColors.skeletonBase,
          highlightColor: AppColors.skeletonHighlight,
          child: Padding(
            padding: EdgeInsets.only(bottom: 10.h),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Full-bleed image area + feature badge placeholder
                Expanded(
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      _block(alpha: 1.0, radius: 0),
                      PositionedDirectional(
                        top: 8.h,
                        start: 8.w,
                        child: _block(
                          height: 18.h,
                          width: 64.w,
                          radius: 20.r,
                          alpha: 0.8,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 12.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // Product name (single bold line)
                      _block(
                        height: 14.h,
                        width: 130.w,
                        radius: 7.r,
                        alpha: 0.9,
                      ),
                      SizedBox(height: 8.h),
                      // Description line 1
                      _block(height: 10.h, width: double.infinity, alpha: 0.5),
                      SizedBox(height: 6.h),
                      // Description line 2 (shorter, trailing-aligned)
                      _block(
                        height: 10.h,
                        width: 100.w,
                        radius: 5.r,
                        alpha: 0.5,
                      ),
                      SizedBox(height: 12.h),
                      // Price capsule + company name
                      Row(
                        textDirection: TextDirection.rtl,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _block(
                            height: 20.h,
                            width: 58.w,
                            radius: 20.r,
                            alpha: 0.75,
                          ),
                          _block(
                            height: 10.h,
                            width: 70.w,
                            radius: 5.r,
                            alpha: 0.4,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
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
