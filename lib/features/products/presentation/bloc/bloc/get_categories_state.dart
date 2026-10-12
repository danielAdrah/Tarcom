part of 'get_categories_bloc.dart';

sealed class GetCategoriesState extends Equatable {
  const GetCategoriesState();

  @override
  List<Object> get props => [];
}

final class GetCategoriesInitial extends GetCategoriesState {}

/// أثناء تحميل الفئات.
class GetCategoriesLoading extends GetCategoriesState {
  const GetCategoriesLoading();
}

/// تم جلب الفئات بنجاح.
class GetCategoriesSuccess extends GetCategoriesState {
  final CategoriesResponseEntity response;

  const GetCategoriesSuccess({required this.response});

  @override
  List<Object> get props => [response];
}

/// فشل طلب جلب الفئات.
class GetCategoriesFailure extends GetCategoriesState {
  final String message;
  final ApiException? exception;

  const GetCategoriesFailure({required this.message, this.exception});

  @override
  List<Object> get props => [message, ?exception];
}
