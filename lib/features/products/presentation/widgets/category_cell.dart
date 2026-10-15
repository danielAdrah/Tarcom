import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/constants/colors.dart';
import '../../domain/entities/category_entity.dart';

class CategoryCell extends StatelessWidget {
  const CategoryCell({required this.category, this.onTap, super.key});

  final CategoryEntity category;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Material(
      color: AppColors.surface,
      // color: Colors.white,
      borderRadius: BorderRadius.circular(16.r),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.r),
        child: Container(
          padding: EdgeInsets.fromLTRB(12.w, 12.h, 12.w, 10.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: AppColors.border),
            boxShadow: [
              //because of the shadow the card is not in plain white so the image bg is visiable
              //we can remove the shadow to make the card plain white
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.06),
                blurRadius: 12.r,
                offset: Offset(0, 5.h),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(child: Center(child: _buildCategoryImage())),
              SizedBox(height: 10.h),
              Row(
                textDirection: TextDirection.rtl,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          category.nameAr.isNotEmpty
                              ? category.nameAr
                              : category.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textDirection: TextDirection.rtl,
                          style: textTheme.titleSmall?.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          'استكشف المنتجات',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textDirection: TextDirection.rtl,
                          style: textTheme.labelSmall?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.chevron_right_rounded,
                    size: 30.w,
                    color: AppColors.primary,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryImage() {
    //here first it checks if the category has an image, if not it uses the icon, and if both are empty it shows a fallback icon
    final imageUrl = category.image.isNotEmpty ? category.image : category.icon;

    if (imageUrl.isEmpty) {
      return _imageFallback();
    }

    return CachedNetworkImage(
      imageUrl: imageUrl,
      width: 140.w,
      height: 140.h,
      fit: BoxFit.contain,
      placeholder: (context, url) => _ImageShimmer(),
      errorWidget: (context, url, error) {
        if (imageUrl != category.icon && category.icon.isNotEmpty) {
          return CachedNetworkImage(
            imageUrl: category.icon,
            width: 140.w,
            height: 140.h,
            fit: BoxFit.contain,
            errorWidget: (_, _, _) => _imageFallback(),
          );
        }

        return _imageFallback();
      },
    );
  }

  Widget _imageFallback() {
    return Icon(
      Icons.image_not_supported_outlined,
      size: 42.w,
      color: AppColors.textSecondary,
    );
  }
}

class _ImageShimmer extends StatelessWidget {
  const _ImageShimmer();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.skeletonBase,
      highlightColor: AppColors.skeletonHighlight,
      child: Container(
        color: Colors.white.withValues(alpha: 0.55),
        child: Center(
          child: Icon(
            Icons.inventory_2_outlined,
            size: 36.w,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
