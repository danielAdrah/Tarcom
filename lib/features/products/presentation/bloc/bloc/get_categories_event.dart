part of 'get_categories_bloc.dart';

sealed class GetCategoriesEvent extends Equatable {
  const GetCategoriesEvent();

  @override
  List<Object> get props => [];
}

/// جلب الفئات لأول مرة أو إعادة المحاولة بعد الفشل.
class GetCategoriesRequested extends GetCategoriesEvent {
  const GetCategoriesRequested();
}

/// إعادة جلب الفئات، مثلاً عند السحب للتحديث.
class GetCategoriesRefreshRequested extends GetCategoriesEvent {
  const GetCategoriesRefreshRequested();
}

/// إعادة الحالة إلى Initial.
class GetCategoriesReset extends GetCategoriesEvent {
  const GetCategoriesReset();
}
