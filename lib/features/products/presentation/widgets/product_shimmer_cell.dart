import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/constants/colors.dart';

/// Skeleton mirror of ProductCell: separate shimmer blocks for the product
/// image, favorite button, title, description lines, price, and availability
/// chip so the loading state matches the real cell 1:1. Block opacity
/// encodes visual hierarchy.
class ProductShimmerCell extends StatelessWidget {
  const ProductShimmerCell({super.key});

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
            // Product image area + favorite button placeholder
            Expanded(
              child: Stack(
                children: [
                  Center(
                    child: _block(
                      height: 115.h,
                      width: 115.w,
                      radius: 14.r,
                      alpha: 1.0,
                    ),
                  ),
                  PositionedDirectional(
                    top: 8.h,
                    end: 8.w,
                    child: _block(
                      height: 32.r,
                      width: 32.r,
                      radius: 32.r,
                      alpha: 0.8,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10.h),
            // Product title (single bold line)
            _block(height: 14.h, width: 140.w, radius: 7.r, alpha: 0.9),
            SizedBox(height: 6.h),
            // Description line 1
            _block(height: 10.h, width: double.infinity, alpha: 0.5),
            SizedBox(height: 5.h),
            // Description line 2 (shorter)
            _block(height: 10.h, width: 90.w, alpha: 0.5),
            SizedBox(height: 10.h),
            // Price + availability chip
            Row(
              textDirection: TextDirection.rtl,
              children: [
                _block(height: 14.h, width: 60.w, alpha: 0.85),
                const Spacer(),
                _block(height: 18.h, width: 46.w, radius: 7.r, alpha: 0.6),
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
