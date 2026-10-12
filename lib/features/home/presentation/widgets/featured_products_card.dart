import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/colors.dart';
import '../../domain/entities/featured_material_entity.dart';

class FeaturedProCard extends StatefulWidget {
  const FeaturedProCard({super.key, required this.material, this.onTap});

  final FeaturedMaterialEntity material;
  final VoidCallback? onTap;

  @override
  State<FeaturedProCard> createState() => _FeaturedProCardState();
}

class _FeaturedProCardState extends State<FeaturedProCard> {
  // حالة الضغط لتأثير التكبير (micro-interaction)
  bool _isPressed = false;

  FeaturedMaterialEntity get material => widget.material;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return AnimatedScale(
      scale: _isPressed ? 1.08 : 1.0,
      duration: const Duration(milliseconds: 120),
      curve: Curves.easeOut,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18.r),
          boxShadow: _isPressed
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.10),
                    blurRadius: 8.r,
                    offset: Offset(0, 3.h),
                  ),
                ]
              : [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.14),
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
        child: Material(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(18.r),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            onTap: widget.onTap,
            onTapDown: (_) => setState(() => _isPressed = true),
            onTapUp: (_) => setState(() => _isPressed = false),
            onTapCancel: () => setState(() => _isPressed = false),
            child: Padding(
              padding: EdgeInsets.only(bottom: 10.h),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // الصورة مع شارة سبب التمييز
                  Expanded(
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        _buildImage(),
                        PositionedDirectional(
                          top: 8.h,
                          start: 8.w,
                          child: _FeatureBadge(reason: material.featureReason),
                        ),
                      ],
                    ),
                  ),
                  // اسم المنتج
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          material.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textDirection: TextDirection.rtl,
                          style: textTheme.titleSmall?.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w700,
                          ),
                          textAlign: TextAlign.end,
                        ),
                        SizedBox(height: 2.h),
                        // الوصف المختصر
                        Text(
                          material.description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textDirection: TextDirection.rtl,
                          style: textTheme.labelSmall?.copyWith(
                            color: AppColors.textSecondary,
                            height: 1.4,
                          ),
                          textAlign: TextAlign.end,
                        ),
                        SizedBox(height: 6.h),
                        // الشركة المصنّعة + السعر
                        Row(
                          textDirection: TextDirection.rtl,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // السعر داخل حلقة ملوّرة لسهولة المسح البصري
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8.w,
                                vertical: 3.h,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.orange50,
                                borderRadius: BorderRadius.circular(20.r),
                                border: Border.all(color: AppColors.orange100),
                              ),
                              child: Text(
                                '${_formatPrice(material.consumerPrice)} \$',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                textDirection: TextDirection.ltr,
                                style: textTheme.titleSmall?.copyWith(
                                  color: AppColors.secondary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Flexible(
                              child: Padding(
                                padding: EdgeInsetsDirectional.only(start: 8.w),
                                child: Text(
                                  material.company,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  textDirection: TextDirection.ltr,
                                  textAlign: TextAlign.start,
                                  style: textTheme.labelSmall?.copyWith(
                                    color: AppColors.textDisabled,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
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
      ),
    );
  }

  Widget _buildImage() {
    final imageUrl = material.image;

    if (imageUrl == null) {
      return _imagePlaceholder();
    }

    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: BoxFit.contain,
      fadeInDuration: const Duration(milliseconds: 250),
      fadeInCurve: Curves.easeOutCubic,
      placeholder: (context, url) => _imagePlaceholder(isLoading: true),
      errorWidget: (context, url, error) => _imagePlaceholder(),
    );
  }

  Widget _imagePlaceholder({bool isLoading = false}) {
    return Container(
      color: AppColors.blue50,
      child: Center(
        child: isLoading
            ? _LoadingPulse(
                child: SizedBox(
                  width: 24.w,
                  height: 24.w,
                  child: const CircularProgressIndicator(
                    strokeWidth: 2.5,
                    color: AppColors.primary,
                  ),
                ),
              )
            : Icon(
                Icons.inventory_2_outlined,
                size: 36.w,
                color: AppColors.blue100,
              ),
      ),
    );
  }

  String _formatPrice(double price) {
    // عرض السعر بدون كسور إذا كان رقماً صحيحاً (1000 وليس 1000.00)
    return price == price.roundToDouble()
        ? price.toStringAsFixed(0)
        : price.toStringAsFixed(2);
  }
}

/// نبض خفيف أثناء تحميل الصورة من الكاش/الشبكة.
class _LoadingPulse extends StatefulWidget {
  const _LoadingPulse({required this.child});

  final Widget child;

  @override
  State<_LoadingPulse> createState() => _LoadingPulseState();
}

class _LoadingPulseState extends State<_LoadingPulse>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);

    _animation = Tween<double>(
      begin: 0.45,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(opacity: _animation, child: widget.child);
  }
}

/// شارة سبب التمييز: عرض / لفترة محدودة / مميز.
class _FeatureBadge extends StatelessWidget {
  const _FeatureBadge({required this.reason});

  final FeatureReason reason;

  @override
  Widget build(BuildContext context) {
    if (reason == FeatureReason.unknown) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 9.w, vertical: 4.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [_color, _color.withValues(alpha: 0.85)],
        ),
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: _color.withValues(alpha: 0.35),
            blurRadius: 6.r,
            offset: Offset(0, 2.h),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_icon, size: 12.w, color: Colors.white),
          SizedBox(width: 4.w),
          Text(
            _label,
            textDirection: TextDirection.rtl,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  IconData get _icon {
    switch (reason) {
      case FeatureReason.offer:
        return Icons.local_offer_rounded;
      case FeatureReason.limitedTime:
        return Icons.schedule_rounded;
      case FeatureReason.special:
        return Icons.workspace_premium_rounded;
      case FeatureReason.unknown:
        return Icons.star_rounded;
    }
  }

  String get _label {
    switch (reason) {
      case FeatureReason.offer:
        return 'عرض';
      case FeatureReason.limitedTime:
        return 'لفترة محدودة';
      case FeatureReason.special:
        return 'مميز';
      case FeatureReason.unknown:
        return '';
    }
  }

  Color get _color {
    switch (reason) {
      case FeatureReason.offer:
        return AppColors.secondary;
      case FeatureReason.limitedTime:
        return AppColors.warning;
      case FeatureReason.special:
        return AppColors.primary;
      case FeatureReason.unknown:
        return AppColors.textSecondary;
    }
  }
}
