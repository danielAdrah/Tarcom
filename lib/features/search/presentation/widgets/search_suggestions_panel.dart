import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/colors.dart';
import '../../../products/domain/entities/material_entity.dart';
import 'search_suggestion_shimmer.dart';

/// لوحة المرشّحات التي تظهر أسفل شريط البحث. تعرض الحالة المناسبة:
/// تحميل (shimmer)، نتائج (قائمة صفوف)، فارغة، أو خطأ مع إعادة محاولة.
///
/// لا تعرف اللوحة شيئاً عن الـ Cubit؛ تتلقى [state]-محتوى جاهزاً عبر الحقول
/// وتُبلّغ التفاعلات عبر Callbacks، لتبقى عرضاً خالصاً قابلاً للاختبار.
class SearchSuggestionsPanel extends StatelessWidget {
  const SearchSuggestionsPanel({
    super.key,
    required this.isLoading,
    this.items = const [],
    this.isEmpty = false,
    this.errorMessage,
    this.showSeeAll = false,
    required this.onSelect,
    required this.onSeeAll,
    this.onRetry,
  });

  final bool isLoading;
  final List<MaterialEntity> items;
  final bool isEmpty;
  final String? errorMessage;
  final bool showSeeAll;
  final void Function(MaterialEntity material) onSelect;
  final VoidCallback onSeeAll;
  final VoidCallback? onRetry;

  static const int _loadingRowCount = 3;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(16.r),
      elevation: 6,
      shadowColor: AppColors.primary.withValues(alpha: 0.25),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.r),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.sizeOf(context).height * 0.5,
          ),
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(vertical: 6.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isLoading)
                  ...List.generate(
                    _loadingRowCount,
                    (_) => const SearchSuggestionShimmer(),
                  )
                else if (errorMessage != null)
                  _buildMessageState(
                    icon: Icons.cloud_off_rounded,
                    iconColor: Theme.of(context).colorScheme.error,
                    text: errorMessage!,
                    actionLabel: 'إعادة المحاولة',
                    onAction: onRetry,
                    context: context,
                  )
                else if (isEmpty)
                  _buildMessageState(
                    icon: Icons.search_off_rounded,
                    iconColor: AppColors.primary,
                    text: 'لا توجد نتائج مطابقة',
                    context: context,
                  )
                else ...[
                  for (final material in items)
                    _SuggestionRow(
                      material: material,
                      onTap: () => onSelect(material),
                    ),
                  if (showSeeAll)
                    InkWell(
                      onTap: onSeeAll,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 12.h,
                        ),
                        child: Row(
                          textDirection: TextDirection.rtl,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'عرض الكل',
                              style: textTheme.titleSmall?.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(width: 6.w),
                            Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 14.w,
                              color: AppColors.primary,
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMessageState({
    required IconData icon,
    required Color iconColor,
    required String text,
    String? actionLabel,
    required BuildContext context,
    VoidCallback? onAction,
  }) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 22.h),
      child: Column(
        children: [
          Icon(icon, size: 34.w, color: iconColor),
          SizedBox(height: 10.h),
          Text(
            text,
            textAlign: TextAlign.center,
            style: textTheme.bodyMedium?.copyWith(color: AppColors.textPrimary),
          ),
          if (actionLabel != null && onAction != null) ...[
            SizedBox(height: 12.h),
            TextButton.icon(
              onPressed: onAction,
              icon: Icon(Icons.refresh_rounded, size: 18.w),
              label: Text(actionLabel),
              style: TextButton.styleFrom(foregroundColor: AppColors.primary),
            ),
          ],
        ],
      ),
    );
  }
}

/// صف مرشّح واحد: صورة مصغّرة + الاسم + الشركة + السعر.
class _SuggestionRow extends StatelessWidget {
  const _SuggestionRow({required this.material, required this.onTap});

  final MaterialEntity material;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final image = material.image;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        child: Row(
          textDirection: TextDirection.rtl,
          children: [
            Container(
              width: 44.r,
              height: 44.r,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: AppColors.blue50,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: (image == null || image.isEmpty)
                  ? Icon(
                      Icons.image_not_supported_outlined,
                      size: 22.r,
                      color: AppColors.textSecondary,
                    )
                  : CachedNetworkImage(
                      imageUrl: image,
                      fit: BoxFit.contain,
                      fadeInDuration: const Duration(milliseconds: 200),
                      errorWidget: (_, _, _) => Icon(
                        Icons.broken_image_outlined,
                        size: 22.r,
                        color: AppColors.textSecondary,
                      ),
                    ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    material.displayTitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.right,
                    style: textTheme.titleSmall?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 3.h),
                  Row(
                    textDirection: TextDirection.rtl,
                    children: [
                      Flexible(
                        child: Text(
                          material.companyName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: textTheme.labelSmall?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '${material.consumerPriceLabel}\$',
                        style: textTheme.labelMedium?.copyWith(
                          color: AppColors.secondary,
                          fontWeight: FontWeight.w700,
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
    );
  }
}
