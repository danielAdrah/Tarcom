import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/colors.dart';

class ProductCell extends StatefulWidget {
  const ProductCell({
    this.onTap,
    required this.proImg,
    required this.proTitle,
    required this.proDesc,
    super.key,
  });
  final VoidCallback? onTap;
  final String proImg;
  final String proTitle;
  final String proDesc;

  @override
  State<ProductCell> createState() => _ProductCellState();
}

class _ProductCellState extends State<ProductCell> {
  bool _isFavorite = false;

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
                          color: AppColors.blue50,
                          borderRadius: BorderRadius.circular(14.r),
                        ),
                        child: Center(
                          child: Image.asset(
                            widget.proImg,
                            width: 128.w,
                            height: 128.h,
                            fit: BoxFit.contain,
                          ),
                        ),
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
                          onPressed: () =>
                              setState(() => _isFavorite = !_isFavorite),
                          constraints: BoxConstraints.tightFor(
                            width: 32.r,
                            height: 32.r,
                          ),
                          padding: EdgeInsets.zero,
                          icon: Icon(
                            _isFavorite
                                ? Icons.favorite_rounded
                                : Icons.favorite_border_rounded,
                            size: 17.r,
                            color: _isFavorite
                                ? AppColors.secondary
                                : AppColors.textSecondary,
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
                    '500\$',
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
                      color: AppColors.orange50,
                      borderRadius: BorderRadius.circular(7.r),
                    ),
                    child: Text(
                      'متوفر',
                      style: textTheme.labelSmall?.copyWith(
                        color: AppColors.orange800,
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
}
