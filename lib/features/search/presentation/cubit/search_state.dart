part of 'search_cubit.dart';

/// حالات البحث الفوري في الصفحة الرئيسية (أسفل شريط البحث).
///
/// مصمّمة لتكون خفيفة وقصيرة العمر: `initial` تعني "لا لوحة مرشّحات"،
/// وبقية الحالات تحمل النص المعروض لإبقاء اللوحة متزامنة مع حقل الإدخال.
sealed class SearchState {
  const SearchState();
}

/// لا توجد نتائج معروضة (حقل فارغ أو أقصر من الحد الأدنى).
final class SearchInitial extends SearchState {
  const SearchInitial();
}

/// جارٍ تنفيذ بحث عن [query].
final class SearchLoading extends SearchState {
  const SearchLoading(this.query);
  final String query;
}

/// تم جلب نتائج لـ [query]. [truncated] تشير إلى وجود نتائج إضافية
/// لم تُعرض (تجاوز العدد الأقصى للوحة) لإظهار تذييل "عرض الكل".
final class SearchResults extends SearchState {
  const SearchResults({
    required this.query,
    required this.items,
    required this.truncated,
  });

  final String query;
  final List<MaterialEntity> items;
  final bool truncated;
}

/// البحث عن [query] لم يُرجع أي منتج.
final class SearchEmpty extends SearchState {
  const SearchEmpty(this.query);
  final String query;
}

/// فشل تنفيذ البحث برسالة قابلة للعرض [message].
final class SearchFailure extends SearchState {
  const SearchFailure(this.message);
  final String message;
}
