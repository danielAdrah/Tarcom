import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/colors.dart';

/// مؤشر قياس (Gauge) نصف متحرك لإظهار نسبة اكتمال الملف الشخصي.
///
/// يتقوّس القوس من الصفر حتى القيمة عبر TweenAnimationBuilder،
/// ويتحول لونه إلى الأخضر عند الاكتمال التام.
class CompletenessArc extends StatelessWidget {
  final double value;
  final double size;

  const CompletenessArc({super.key, required this.value, this.size = 104});

  @override
  Widget build(BuildContext context) {
    final double clamped = value.clamp(0.0, 1.0);
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: clamped),
      duration: const Duration(milliseconds: 900),
      curve: Curves.easeOutCubic,
      builder: (context, animated, _) {
        return SizedBox(
          width: size.w,
          height: size.w,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CustomPaint(painter: _ArcPainter(progress: animated)),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    // عدّاد تصاعدي من 0 حتى النسبة النهائية مع القوس.
                    '${(animated * 100).round()}%',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    'مكتمل',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 11.sp,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ArcPainter extends CustomPainter {
  final double progress;

  _ArcPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final double stroke = 11.w;
    final Offset center = Offset(size.width / 2, size.height / 2);
    final double radius =
        (math.min(size.width, size.height) - stroke) / 2 - 2.w;
    final Rect arcRect = Rect.fromCircle(center: center, radius: radius);

    const double startAngle = math.pi * 0.75;
    const double fullSweep = math.pi * 1.5;

    // المسار الخلفي.
    final Paint track = Paint()
      ..color = AppColors.blue100
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(arcRect, startAngle, fullSweep, false, track);

    // قوس التقدم: برتقالي أثناء النقص وأخضر عند الاكتمال.
    if (progress > 0) {
      final Paint valuePaint = Paint()
        ..color = progress >= 1 ? AppColors.success : AppColors.secondary
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke
        ..strokeCap = StrokeCap.round;
      canvas.drawArc(
        arcRect,
        startAngle,
        fullSweep * progress,
        false,
        valuePaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _ArcPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
