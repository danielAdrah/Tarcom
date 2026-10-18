part of 'get_contact_info_bloc.dart';

sealed class GetContactInfoState extends Equatable {
  const GetContactInfoState();

  @override
  List<Object> get props => [];
}

final class GetContactInfoInitial extends GetContactInfoState {}

/// أثناء تحميل معلومات التواصل.
class GetContactInfoLoading extends GetContactInfoState {
  const GetContactInfoLoading();
}

/// تم جلب معلومات التواصل بنجاح.
class GetContactInfoSuccess extends GetContactInfoState {
  final ContactInfoEntity contactInfo;

  const GetContactInfoSuccess({required this.contactInfo});

  @override
  List<Object> get props => [contactInfo];
}

/// فشل طلب جلب معلومات التواصل.
class GetContactInfoFailure extends GetContactInfoState {
  final String message;
  final ApiException? exception;

  const GetContactInfoFailure({required this.message, this.exception});

  @override
  List<Object> get props => [message, ?exception];
}
