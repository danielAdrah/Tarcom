import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/colors.dart';

/// بطاقة زجاجية لبيان واحد (اسم/بريد/هاتف) مع نسخ عند النقر.
///
/// تُلفَّ القيمة بـ Directionality حسب طبيعتها: LTR للبريد والأرقام حتى لا تنقلب،
/// و RTL للأسماء العربية لتُحاذى وتُعرض بشكل صحيح.
class ProfileInfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final TextDirection valueDirection;

  const ProfileInfoTile({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.valueDirection = TextDirection.ltr,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final bool hasValue = value.isNotEmpty;

    return Container(
      padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 12.w),
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.3),
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          // أيقونة داخل شريحة زرقاء فاتحة (نفس نمط صفحة تواصل معنا).
          Container(
            padding: EdgeInsets.all(9.r),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 202, 219, 235),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(icon, size: 24.h, color: AppColors.primary),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: textTheme.bodySmall),
                SizedBox(height: 2.h),
                Directionality(
                  textDirection: valueDirection,
                  child: Text(
                    hasValue ? value : '—',
                    style: textTheme.titleSmall?.copyWith(
                      color: hasValue
                          ? AppColors.textPrimary
                          : AppColors.textDisabled,
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          if (hasValue)
            IconButton(
              tooltip: 'نسخ',
              onPressed: () => _copyToClipboard(context),
              icon: Icon(
                Icons.copy_rounded,
                size: 18.w,
                color: AppColors.textSecondary,
              ),
              splashRadius: 20.r,
            ),
        ],
      ),
    );
  }

  void _copyToClipboard(BuildContext context) {
    Clipboard.setData(ClipboardData(text: value));
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('تم نسخ $label'),
          duration: const Duration(seconds: 2),
        ),
      );
  }
}
