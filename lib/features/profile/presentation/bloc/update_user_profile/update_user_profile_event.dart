part of 'update_user_profile_bloc.dart';

abstract class UpdateUserProfileEvent extends Equatable {
  const UpdateUserProfileEvent();

  @override
  List<Object> get props => [];
}

/// طلب حفظ التعديلات على الملف الشخصي.
class UpdateUserProfileSubmitted extends UpdateUserProfileEvent {
  final UpdateProfileParams params;

  const UpdateUserProfileSubmitted({required this.params});

  @override
  List<Object> get props => [params];
}
