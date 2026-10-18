import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/colors.dart';
import '../../domain/entities/user_profile_entity.dart';
import 'profile_shimmer.dart';

/// بانر الهوية المتقلّص: تدرّج أزرق + بطاقة بيضاء تطفو على حافة البانر،
/// وشارة أحرف أولى بتدرّج برتقالي تنبض فوق حافة البطاقة (لا صور شخصية).
///
/// يتصرّف البانر كـ SliverAppBar مثبت: ينكمش إلى شريط عنوان أزرق أثناء التمرير،
/// ويتمدد بمرونة (stretch) عند السحب قبل التحديث، مع parallax خفيف
/// لطبقات الخلفية أثناء الطي.
class ProfileBanner extends StatelessWidget {
  final UserProfileEntity? profile;
  final bool isLoading;
  final String? failureMessage;
  final VoidCallback onRetry;

  const ProfileBanner({
    super.key,
    required this.profile,
    required this.isLoading,
    this.failureMessage,
    required this.onRetry,
  });

  static const double _expandedHeight = 300;
  static const double _toolbarHeight = 64;
  static const double _cardHeight = 150;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      stretch: true,
      elevation: 0,
      expandedHeight: _expandedHeight.h,
      toolbarHeight: _toolbarHeight.h,
      backgroundColor: AppColors.primary,
      surfaceTintColor: Colors.transparent,
      iconTheme: const IconThemeData(color: AppColors.white),
      flexibleSpace: FlexibleSpaceBar(
        background: LayoutBuilder(
          builder: (context, constraints) {
            // نسبة التمدد/الانكماش للتفاعل مع السحب والطي.
            final double stretch = (constraints.maxHeight / _expandedHeight.h)
                .clamp(0.0, 1.6);
            final double reveal =
                ((constraints.maxHeight - _toolbarHeight.h) /
                        ((_expandedHeight - _toolbarHeight) * 0.6).h)
                    .clamp(0.0, 1.0);
            // إزاحة الطي المستنتجة من انكماش الارتفاع لمحاكاة الـ parallax
            // بين طبقات الخلفية (التمدد يتجاهل لأنه معالجة بالسحب).
            final double scroll = (_expandedHeight.h - constraints.maxHeight)
                .clamp(0.0, 1000.0);

            return Stack(
              clipBehavior: Clip.none,
              children: [
                // التدرّج الأساسي للعلامة التجارية.
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [
                          AppColors.blue900,
                          AppColors.primary,
                          AppColors.blue500,
                        ],
                      ),
                    ),
                  ),
                ),
                // ملمس الخلفية الخاص بالتطبيق بشفافية خفيفة (parallax بطيء).
                Positioned.fill(
                  child: IgnorePointer(
                    child: Transform.translate(
                      offset: Offset(0, scroll * 0.30),
                      child: Opacity(
                        opacity: 0.12,
                        child: Image.asset(
                          'assets/img/bg.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
                // دوائر زخرفية خلف البطاقة تتحرك بسرعات مختلفة لعمق الحركة.
                Positioned(
                  top: -46.h,
                  left: -26.w,
                  child: Transform.translate(
                    offset: Offset(0, scroll * 0.55),
                    child: _decorCircle(
                      130.w,
                      Colors.white.withValues(alpha: 0.07),
                    ),
                  ),
                ),
                Positioned(
                  top: 104.h,
                  right: 22.w,
                  child: Transform.translate(
                    offset: Offset(0, scroll * 0.75),
                    child: _decorCircle(
                      56.w,
                      AppColors.secondary.withValues(alpha: 0.20),
                    ),
                  ),
                ),
                // تحية تتقوس مع السحب وتبهت مع الطي.
                // PositionedDirectional(
                //   top: _toolbarHeight.h + 14.h,
                //   start: 16.w,
                //   end: 16.w,
                //   child: Opacity(
                //     opacity: reveal,
                //     child: Transform.translate(
                //       offset: Offset(0, scroll * 0.18),
                //       child: Transform.scale(
                //         scale: stretch > 1 ? 1 + (stretch - 1) * 0.9 : 1.0,
                //         alignment: Alignment.topCenter,
                //         child: FadeInUp(
                //           duration: const Duration(milliseconds: 600),
                //           child: Text(
                //             'أهلاً بك في تاركوم',
                //             textAlign: TextAlign.center,
                //             style: TextStyle(
                //               color: AppColors.white.withValues(alpha: 0.92),
                //               fontSize: 15.sp,
                //               fontWeight: FontWeight.w600,
                //             ),
                //           ),
                //         ),
                //       ),
                //     ),
                //   ),
                // ),

                // بطاقة الهوية الطافية على حافة البانر.
                PositionedDirectional(
                  start: 16.w,
                  end: 16.w,
                  bottom: 16.h,
                  child: _identityCard(context),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _decorCircle(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }

  Widget _identityCard(BuildContext context) {
    return Container(
      height: _cardHeight.h,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.border, width: 1),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.16),
            blurRadius: 18.r,
            offset: Offset(0, 7.h),
          ),
        ],
      ),
      child: _cardContent(context),
    );
  }

  Widget _cardContent(BuildContext context) {
    if (profile == null && !isLoading && failureMessage != null) {
      return _cardFailure(context, failureMessage!);
    }

    if (profile == null) {
      return const ProfileCardSkeleton();
    }

    final UserProfileEntity user = profile!;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // شارة الأحرف الأولى تتوسط حافة البطاقة العليا بدل الصورة الشخصية.
        PositionedDirectional(
          top: -48.h,
          start: 0,
          end: 0,
          child: Center(child: _InitialsBadge(initials: user.initials)),
        ),
        PositionedDirectional(
          top: 56.h,
          start: 14.w,
          end: 14.w,
          bottom: 12.h,
          child: Column(
            children: [
              Text(
                user.fullName.isEmpty ? 'مستخدم تاركوم' : user.fullName,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 8.h),
              _typeBadge(user.userTypeLabel),
            ],
          ),
        ),
      ],
    );
  }

  Widget _typeBadge(String label) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: AppColors.orange100,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.verified_user_outlined,
            size: 14.w,
            color: AppColors.orange800,
          ),
          SizedBox(width: 5.w),
          Text(
            label,
            style: TextStyle(
              color: AppColors.orange800,
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _cardFailure(BuildContext context, String message) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.cloud_off_rounded,
            size: 26.w,
            color: Theme.of(context).colorScheme.error,
          ),
          SizedBox(height: 6.h),
          Text(
            message,
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          TextButton.icon(
            onPressed: onRetry,
            icon: Icon(Icons.refresh_rounded, size: 16.w),
            label: const Text('إعادة المحاولة'),
          ),
        ],
      ),
    );
  }
}

/// شارة الأحرف الأولى: بديل أنيق عن الصورة الشخصية غير المدعومة.
///
/// قرص بتدرّج برتقالي من العلامة التجارية وأحرف الاسم بالأبيض;
/// يظهر بمرونة (easeOutBack) عند التحميل ثم ينبض بهالة خفيفة باستمرار.
class _InitialsBadge extends StatefulWidget {
  final String initials;

  const _InitialsBadge({required this.initials});

  @override
  State<_InitialsBadge> createState() => _InitialsBadgeState();
}

class _InitialsBadgeState extends State<_InitialsBadge>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      // ظهور مرن واحد عند التحميل.
      tween: Tween<double>(begin: 0.4, end: 1.0),
      duration: const Duration(milliseconds: 650),
      curve: Curves.easeOutBack,
      builder: (context, scale, child) =>
          Transform.scale(scale: scale, child: child),
      child: SizedBox(
        width: 116.w,
        height: 116.w,
        child: AnimatedBuilder(
          animation: _pulseController,
          builder: (context, child) {
            final double t = Curves.easeInOut.transform(_pulseController.value);
            return Stack(
              alignment: Alignment.center,
              children: [
                // هالة النبض خلف القرص.
                Container(
                  width: 96.w + 16.w * t,
                  height: 96.w + 16.w * t,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.secondary.withValues(
                      alpha: 0.22 - 0.12 * t,
                    ),
                  ),
                ),
                ?child,
              ],
            );
          },
          child: Container(
            width: 96.w,
            height: 96.w,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  AppColors.orange400,
                  AppColors.secondary,
                  AppColors.orange800,
                ],
              ),
              border: Border.all(color: AppColors.white, width: 3),
              boxShadow: [
                BoxShadow(
                  color: AppColors.secondary.withValues(alpha: 0.35),
                  blurRadius: 14.r,
                  offset: Offset(0, 5.h),
                ),
              ],
            ),
            child: Text(
              widget.initials.isEmpty ? '؟' : widget.initials,
              style: TextStyle(
                color: AppColors.white,
                fontSize: 30.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
