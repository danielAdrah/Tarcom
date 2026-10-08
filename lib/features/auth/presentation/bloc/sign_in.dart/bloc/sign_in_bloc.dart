import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../../core/api/errors/api_excptions.dart';
import '../../../../domain/entities/sign_in_response_entity.dart';
import '../../../../domain/useCases/sign_in_use_case.dart';

part 'sign_in_event.dart';
part 'sign_in_state.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  final SignInUseCase signInUseCase;

  SignInBloc({required this.signInUseCase}) : super(SignInInitial()) {
    on<SignInSubmitted>(_onSignInSubmitted);
    on<SignInReset>(_onSignInReset);
  }

  Future<void> _onSignInSubmitted(
    SignInSubmitted event,
    Emitter<SignInState> emit,
  ) async {
    emit(const SignInLoading());

    try {
      final response = await signInUseCase(
        SignInParams(email: event.email, password: event.password),
      );

      emit(SignInSuccess(response: response));
    } on ApiException catch (e) {
      emit(SignInFailure(message: e.message, exception: e));
    } catch (_) {
      emit(const SignInFailure(message: 'حدث خطأ غير متوقع. حاول مرة أخرى.'));
    }
  }

  void _onSignInReset(SignInReset event, Emitter<SignInState> emit) {
    emit(SignInInitial());
  }
}
