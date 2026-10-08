import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../../core/api/errors/api_excptions.dart';
import '../../../../domain/entities/sign_up_entity.dart';
import '../../../../domain/useCases/sign_up_use_case.dart';

part 'sign_up_event.dart';
part 'sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final SignUpUseCase signUpUseCase;

  SignUpBloc({required this.signUpUseCase}) : super(const SignUpInitial()) {
    on<SignUpSubmitted>(_onSignUpSubmitted);
    on<SignUpReset>(_onSignUpReset);
  }

  Future<void> _onSignUpSubmitted(
    SignUpSubmitted event,
    Emitter<SignUpState> emit,
  ) async {
    emit(const SignUpLoading());

    try {
      final response = await signUpUseCase(
        SignUpParams(
          email: event.email,
          password: event.password,
          firstName: event.firstName,
          lastName: event.lastName,
          phone: event.phone,
          userType: event.userType,
        ),
      );

      emit(SignUpSuccess(response: response));
    } on ApiException catch (e) {
      emit(SignUpFailure(message: e.message, exception: e));
    } catch (e) {
      emit(const SignUpFailure(message: 'حدث خطأ غير متوقع. حاول مرة أخرى.'));
    }
  }

  void _onSignUpReset(SignUpReset event, Emitter<SignUpState> emit) {
    emit(const SignUpInitial());
  }
}
