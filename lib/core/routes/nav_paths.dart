import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

/// أدوات ملاحمة مشتركة لواجهة التفريع السفلي (StatefulShellRoute).
///
/// الصفحة نفسها (شركات/منتجات/تفاصيل) تُستعمل داخل عدة تبويبات،
/// لذا يجب أن يتم التنقّل داخل الفرع الحالي بدل القفز إلى فرع آخر.
class NavPaths {
  NavPaths._();

  // المسارات النسبية للصفحات العميقة المعاد استخدامها داخل كل فرع.
  static const String companies = 'companies';
  static const String products = 'products';
  static const String details = 'details';
  static const String featured = 'featured';
  static const String search = 'search';
  static const String userProfile = 'userProfile';

  /// جذر الفرع النشط (القسم الأول من المسار الحالي) مثل `/homePage`.
  ///
  /// يُستخدم لتركيب مسار مطلق يبقي المستخدم داخل التبويب الحالي
  /// مع بقاء شريط التنقّل السفلي ظاهراً وحالة التبويبات محفوظة.
  static String branchRoot(BuildContext context) {
    final String path = GoRouterState.of(context).uri.path;
    final List<String> segments = path
        .split('/')
        .where((String s) => s.isNotEmpty)
        .toList();
    return segments.isEmpty ? '/' : '/${segments.first}';
  }

  /// مسار مطلق لصفحة عميقة داخل الفرع الحالي.
  static String withinBranch(BuildContext context, String child) =>
      '${branchRoot(context)}/$child';
}
