import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/api/errors/api_excptions.dart';
import '../../../domain/entities/update_profile_params.dart';
import '../../../domain/entities/user_profile_entity.dart';
import '../../../domain/usecases/update_user_profile_use_case.dart';

part 'update_user_profile_event.dart';
part 'update_user_profile_state.dart';

/// يدير عملية تحديث الملف الشخصي عبر `PUT /api/users/me/`.
class UpdateUserProfileBloc
    extends Bloc<UpdateUserProfileEvent, UpdateUserProfileState> {
  final UpdateUserProfileUseCase updateUserProfileUseCase;

  UpdateUserProfileBloc({required this.updateUserProfileUseCase})
    : super(UpdateUserProfileInitial()) {
    on<UpdateUserProfileSubmitted>(_onSubmit);
  }

  Future<void> _onSubmit(
    UpdateUserProfileSubmitted event,
    Emitter<UpdateUserProfileState> emit,
  ) async {
    emit(const UpdateUserProfileLoading());

    try {
      final profile = await updateUserProfileUseCase(event.params);
      emit(UpdateUserProfileSuccess(userProfile: profile));
    } on ApiException catch (e) {
      emit(UpdateUserProfileFailure(message: e.message, exception: e));
    } catch (_) {
      emit(
        const UpdateUserProfileFailure(
          message: 'حدث خطأ غير متوقع. حاول مرة أخرى.',
        ),
      );
    }
  }
}
