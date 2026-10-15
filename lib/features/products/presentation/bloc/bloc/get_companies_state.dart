part of 'get_companies_bloc.dart';

sealed class GetCompaniesState extends Equatable {
  const GetCompaniesState();

  @override
  List<Object> get props => [];
}

final class GetCompaniesInitial extends GetCompaniesState {}

/// أثناء تحميل الشركات.
class GetCompaniesLoading extends GetCompaniesState {
  const GetCompaniesLoading();
}

/// تم جلب الشركات بنجاح.
class GetCompaniesSuccess extends GetCompaniesState {
  final List<CompanyEntity> companies;

  const GetCompaniesSuccess({required this.companies});

  @override
  List<Object> get props => [companies];
}

/// فشل طلب جلب الشركات.
class GetCompaniesFailure extends GetCompaniesState {
  final String message;
  final ApiException? exception;

  const GetCompaniesFailure({required this.message, this.exception});

  @override
  List<Object> get props => [message, ?exception];
}
