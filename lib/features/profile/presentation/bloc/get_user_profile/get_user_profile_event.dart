part of 'get_user_profile_bloc.dart';

abstract class GetUserProfileEvent extends Equatable {
  const GetUserProfileEvent();

  @override
  List<Object> get props => [];
}

/// طلب أول تحميل للملف الشخصي.
class GetUserProfileRequested extends GetUserProfileEvent {
  const GetUserProfileRequested();
}

/// طلب إعادة التحميل (سحب للتحديث أو إعادة المحاولة بعد الفشل).
class GetUserProfileRefreshRequested extends GetUserProfileEvent {
  const GetUserProfileRefreshRequested();
}

/// تحديث الحالة محلياً بعد نجاح تعديل الملف، دون إعادة جلب من الشبكة.
class GetUserProfileUpdated extends GetUserProfileEvent {
  final UserProfileEntity profile;

  const GetUserProfileUpdated({required this.profile});

  @override
  List<Object> get props => [profile];
}
