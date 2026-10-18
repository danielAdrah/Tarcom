import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/colors.dart';
import '../../domain/entities/user_profile_entity.dart';
import 'completeness_arc.dart';

/// بطاقة اكتمال الملف الشخصي: مؤشر قوسي متحرك + بيان الحقول الناقصة.
class CompletenessCard extends StatelessWidget {
  final UserProfileEntity profile;

  const CompletenessCard({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final List<String> missing = _missingFields();

    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 14.w),
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.3),
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        children: [
          CompletenessArc(value: profile.completeness),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'اكتمال الملف الشخصي',
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  missing.isEmpty
                      ? 'ملفك مكتمل بالكامل، شكراً لثقتك بتاركوم.'
                      : 'ما زال ناقص: ${missing.join('، ')} — أكملها لتجربة أفضل.',
                  style: textTheme.bodySmall?.copyWith(height: 1.5),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<String> _missingFields() {
    // الصورة الشخصية غير مدعومة حالياً فلا تُدرج ضمن الناقص.
    return <String>[
      if (profile.fullName.isEmpty) 'الاسم',
      if (profile.email.isEmpty) 'البريد الإلكتروني',
      if (profile.phone.isEmpty) 'رقم الهاتف',
    ];
  }
}
