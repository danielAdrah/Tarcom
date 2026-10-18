import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/api/errors/api_excptions.dart';
import '../../../domain/entities/user_profile_entity.dart';
import '../../../domain/usecases/get_user_profile_use_case.dart';

part 'get_user_profile_event.dart';
part 'get_user_profile_state.dart';

class GetUserProfileBloc
    extends Bloc<GetUserProfileEvent, GetUserProfileState> {
  final GetUserProfileUseCase getUserProfileUseCase;

  GetUserProfileBloc({required this.getUserProfileUseCase})
    : super(GetUserProfileInitial()) {
    on<GetUserProfileRequested>(_onFetchUserProfile);
    on<GetUserProfileRefreshRequested>(_onFetchUserProfile);
    on<GetUserProfileUpdated>(_onUpdated);
  }

  Future<void> _onUpdated(
    GetUserProfileUpdated event,
    Emitter<GetUserProfileState> emit,
  ) async {
    // يعكس نتيجة التحديث الناجح فوراً دون طلب شبكة إضافي.
    emit(GetUserProfileSuccess(userProfile: event.profile));
  }

  Future<void> _onFetchUserProfile(
    GetUserProfileEvent event,
    Emitter<GetUserProfileState> emit,
  ) async {
    emit(const GetUserProfileLoading());

    try {
      final profile = await getUserProfileUseCase();
      emit(GetUserProfileSuccess(userProfile: profile));
    } on ApiException catch (e) {
      emit(GetUserProfileFailure(message: e.message, exception: e));
    } catch (_) {
      emit(
        const GetUserProfileFailure(
          message: 'حدث خطأ غير متوقع. حاول مرة أخرى.',
        ),
      );
    }
  }
}
