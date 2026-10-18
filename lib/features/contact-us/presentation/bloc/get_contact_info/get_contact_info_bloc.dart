import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/api/errors/api_excptions.dart';
import '../../../domain/entities/contact_info_entity.dart';
import '../../../domain/usecases/get_contact_info_use_case.dart';

part 'get_contact_info_event.dart';
part 'get_contact_info_state.dart';

class GetContactInfoBloc
    extends Bloc<GetContactInfoEvent, GetContactInfoState> {
  final GetContactInfoUseCase getContactInfoUseCase;

  GetContactInfoBloc({required this.getContactInfoUseCase})
    : super(GetContactInfoInitial()) {
    on<GetContactInfoRequested>(_onFetchContactInfo);
    on<GetContactInfoRefreshRequested>(_onFetchContactInfo);
  }

  Future<void> _onFetchContactInfo(
    GetContactInfoEvent event,
    Emitter<GetContactInfoState> emit,
  ) async {
    emit(const GetContactInfoLoading());

    try {
      final contactInfo = await getContactInfoUseCase();
      emit(GetContactInfoSuccess(contactInfo: contactInfo));
    } on ApiException catch (e) {
      emit(GetContactInfoFailure(message: e.message, exception: e));
    } catch (_) {
      emit(
        const GetContactInfoFailure(
          message: 'حدث خطأ غير متوقع. حاول مرة أخرى.',
        ),
      );
    }
  }
}
