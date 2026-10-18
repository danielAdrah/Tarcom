import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/colors.dart';

/// حقل قابل للتحرير داخل بطاقة زجاجية مطابقة لنمط [ProfileInfoTile].
///
/// يُستخدم في وضع تعديل الملف الشخصي: شريحة أيقونة زرقاء، تسمية صغيرة،
/// ثم `TextFormField` باتجاه صحيح (RTL للأسماء العربية، LTR للهاتف).
class ProfileEditField extends StatelessWidget {
  final IconData icon;
  final String label;
  final TextEditingController controller;
  final TextDirection valueDirection;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? inputFormatters;
  final String? hintText;
  final int? maxLength;

  const ProfileEditField({
    super.key,
    required this.icon,
    required this.label,
    required this.controller,
    this.valueDirection = TextDirection.ltr,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.inputFormatters,
    this.hintText,
    this.maxLength,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 12.w),
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.3),
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
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
            child: Directionality(
              textDirection: valueDirection,
              child: TextFormField(
                controller: controller,
                keyboardType: keyboardType,
                textDirection: valueDirection,
                inputFormatters: inputFormatters,
                maxLength: maxLength,
                validator: validator,
                style: textTheme.titleSmall?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
                decoration: InputDecoration(
                  isDense: true,
                  counterText: '',
                  labelText: label,
                  labelStyle: textTheme.bodySmall,
                  hintText: hintText,
                  hintStyle: textTheme.bodySmall?.copyWith(
                    color: AppColors.textDisabled,
                  ),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  focusedErrorBorder: InputBorder.none,
                  errorStyle: textTheme.bodySmall?.copyWith(
                    color: AppColors.error,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
