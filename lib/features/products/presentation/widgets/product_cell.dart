import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/constants/colors.dart';

class ProductCell extends StatefulWidget {
  const ProductCell({
    this.onTap,
    required this.proImg,
    required this.proTitle,
    required this.proDesc,
    this.proPrice,
    this.isAvailable = true,
    required this.favToggle,
    this.isFavorite = false,
    this.isFavoriteLoading = false,

    super.key,
  });
  final VoidCallback? onTap;
  final String proImg;
  final String proTitle;
  final String proDesc;
  final String? proPrice;
  final bool isAvailable;
  final void Function()? favToggle;

  /// حالة المفضلة الحالية للمنتج (قلب ممتلئ/مُحدّد عند true). يديرها الـ Bloc من الأعلى.
  final bool isFavorite;

  /// أثناء إرسال طلب التبديل: تُظهر مؤشراً تحميل صغيراً وتعطّل الزر مؤقتاً.
  final bool isFavoriteLoading;

  @override
  State<ProductCell> createState() => _ProductCellState();
}

class _ProductCellState extends State<ProductCell> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Material(
      borderRadius: BorderRadius.circular(16.r),
      child: InkWell(
        onTap: widget.onTap,
        borderRadius: BorderRadius.circular(16.r),
        child: Container(
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
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.3),
                blurRadius: 12.r,
                offset: Offset(0, 5.h),
              ),
              BoxShadow(),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Stack(
                  children: [
                    Center(
                      child: Container(
                        margin: EdgeInsets.all(4.r),
                        decoration: BoxDecoration(
                          // color: AppColors.blue50,
                          borderRadius: BorderRadius.circular(14.r),
                        ),
                        child: Center(child: _buildProductImage()),
                      ),
                    ),
                    PositionedDirectional(
                      top: 8.h,
                      end: 8.w,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.08),
                              blurRadius: 8.r,
                            ),
                          ],
                        ),
                        child: IconButton(
                          // تعطيل الزر أثناء الطلب لتفادي الضغط المزدوج.
                          onPressed: widget.isFavoriteLoading
                              ? null
                              : widget.favToggle,

                          constraints: BoxConstraints.tightFor(
                            width: 32.r,
                            height: 32.r,
                          ),
                          padding: EdgeInsets.zero,
                          // مؤشر تحميل أثناء الطلب، وإلا أيقونة القلب حسب الحالة.
                          icon: widget.isFavoriteLoading
                              ? SizedBox(
                                  width: 17.r,
                                  height: 17.r,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.r,
                                    color: AppColors.secondary,
                                  ),
                                )
                              : AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 180),
                                  child: Icon(
                                    widget.isFavorite
                                        ? Icons.favorite_rounded
                                        : Icons.favorite_border_rounded,
                                    key: ValueKey(widget.isFavorite),
                                    size: 17.r,
                                    color: widget.isFavorite
                                        ? AppColors.secondary
                                        : AppColors.textSecondary,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10.h),
              Text(
                widget.proTitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textDirection: TextDirection.rtl,
                style: textTheme.titleSmall?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 3.h),
              Text(
                widget.proDesc,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textDirection: TextDirection.rtl,
                style: textTheme.labelSmall?.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.3,
                ),
              ),
              SizedBox(height: 9.h),
              Row(
                textDirection: TextDirection.rtl,
                children: [
                  Text(
                    (widget.proPrice?.isNotEmpty ?? false)
                        ? '${widget.proPrice}\$'
                        : '',
                    style: textTheme.titleSmall?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 7.w,
                      vertical: 3.h,
                    ),
                    decoration: BoxDecoration(
                      color: widget.isAvailable
                          ? AppColors.orange50
                          : AppColors.blue50,
                      borderRadius: BorderRadius.circular(7.r),
                    ),
                    child: Text(
                      widget.isAvailable ? 'متوفر' : 'غير متوفر',
                      style: textTheme.labelSmall?.copyWith(
                        color: widget.isAvailable
                            ? AppColors.orange800
                            : AppColors.primary,
                        fontSize: 9.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// بديل shimmer أثناء تحميل الصورة من الكاش/الشبكة.
  Widget _imageShimmerPlaceholder(Size size) {
    return Shimmer.fromColors(
      baseColor: AppColors.skeletonBase,
      highlightColor: AppColors.skeletonHighlight,
      child: Container(
        width: size.width.w,
        height: size.height.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14.r),
        ),
      ),
    );
  }

  /// يعرض صورة شبكية عند كون الرابط HTTP، وإلا صورة أصلية من الأصول،
  /// مع بدائل أثناء التحميل وعند الخطأ.
  Widget _buildProductImage() {
    final image = widget.proImg;
    const size = Size(128, 128);
    final isRemote = image.startsWith('http');

    if (image.isEmpty) {
      return Icon(
        Icons.image_not_supported_outlined,
        size: 48.w,
        color: AppColors.textSecondary,
      );
    }

    if (isRemote) {
      return CachedNetworkImage(
        imageUrl: image,
        width: size.width.w,
        height: size.height.h,
        fit: BoxFit.contain,
        fadeInDuration: const Duration(milliseconds: 250),
        fadeInCurve: Curves.easeOutCubic,
        placeholder: (context, url) => _imageShimmerPlaceholder(size),
        errorWidget: (context, url, error) => Icon(
          Icons.broken_image_outlined,
          size: 48.w,
          color: AppColors.textSecondary,
        ),
      );
    }

    return Image.asset(
      image,
      width: size.width.w,
      height: size.height.h,
      fit: BoxFit.contain,
      errorBuilder: (_, _, _) => Icon(
        Icons.image_not_supported_outlined,
        size: 48.w,
        color: AppColors.textSecondary,
      ),
    );
  }
}
