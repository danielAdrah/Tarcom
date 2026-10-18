part of 'get_user_profile_bloc.dart';

abstract class GetUserProfileState extends Equatable {
  const GetUserProfileState();

  @override
  List<Object> get props => [];
}

class GetUserProfileInitial extends GetUserProfileState {
  const GetUserProfileInitial();
}

class GetUserProfileLoading extends GetUserProfileState {
  const GetUserProfileLoading();
}

class GetUserProfileSuccess extends GetUserProfileState {
  final UserProfileEntity userProfile;

  const GetUserProfileSuccess({required this.userProfile});

  // نتضمّن الحقول القابلة للتعديل حتى تُعتبر الحالة جديدة بعد الحفظ
  // ويُعِد BlocBuilder البناء فوراً لانعكاس الاسم/الهاتف الجديدين دون تحديث الصفحة.
  @override
  List<Object> get props => [
    userProfile.id,
    userProfile.email,
    userProfile.firstName,
    userProfile.lastName,
    userProfile.phone,
    userProfile.avatar ?? '',
  ];
}

class GetUserProfileFailure extends GetUserProfileState {
  final String message;
  final ApiException? exception;

  const GetUserProfileFailure({required this.message, this.exception});

  @override
  List<Object> get props => [message];
}
