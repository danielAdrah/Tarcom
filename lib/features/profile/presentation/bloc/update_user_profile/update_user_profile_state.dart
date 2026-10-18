part of 'update_user_profile_bloc.dart';

abstract class UpdateUserProfileState extends Equatable {
  const UpdateUserProfileState();

  @override
  List<Object> get props => [];
}

class UpdateUserProfileInitial extends UpdateUserProfileState {
  const UpdateUserProfileInitial();
}

class UpdateUserProfileLoading extends UpdateUserProfileState {
  const UpdateUserProfileLoading();
}

class UpdateUserProfileSuccess extends UpdateUserProfileState {
  final UserProfileEntity userProfile;

  const UpdateUserProfileSuccess({required this.userProfile});

  @override
  List<Object> get props => [userProfile.id, userProfile.email];
}

class UpdateUserProfileFailure extends UpdateUserProfileState {
  final String message;
  final ApiException? exception;

  const UpdateUserProfileFailure({required this.message, this.exception});

  @override
  List<Object> get props => [message];
}
