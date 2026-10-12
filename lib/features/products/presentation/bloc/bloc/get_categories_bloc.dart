import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/api/errors/api_excptions.dart';
import '../../../domain/entities/categories_response_entity.dart';
import '../../../domain/usecases/get_categories_use_case.dart';

part 'get_categories_event.dart';
part 'get_categories_state.dart';

class GetCategoriesBloc extends Bloc<GetCategoriesEvent, GetCategoriesState> {
  final GetCategoriesUseCase getCategoriesUseCase;

  GetCategoriesBloc({required this.getCategoriesUseCase})
    : super(GetCategoriesInitial()) {
    on<GetCategoriesRequested>(_onGetCategoriesRequested);
    on<GetCategoriesRefreshRequested>(_onGetCategoriesRefreshRequested);
    on<GetCategoriesReset>(_onGetCategoriesReset);
  }

  Future<void> _onGetCategoriesRequested(
    GetCategoriesRequested event,
    Emitter<GetCategoriesState> emit,
  ) async {
    await _fetchCategories(emit);
  }

  Future<void> _onGetCategoriesRefreshRequested(
    GetCategoriesRefreshRequested event,
    Emitter<GetCategoriesState> emit,
  ) async {
    await _fetchCategories(emit);
  }

  Future<void> _fetchCategories(Emitter<GetCategoriesState> emit) async {
    emit(const GetCategoriesLoading());

    try {
      final response = await getCategoriesUseCase();

      emit(GetCategoriesSuccess(response: response));
    } on ApiException catch (e) {
      emit(GetCategoriesFailure(message: e.message, exception: e));
    } catch (_) {
      emit(
        const GetCategoriesFailure(
          message: 'حدث خطأ غير متوقع. حاول مرة أخرى.',
        ),
      );
    }
  }

  void _onGetCategoriesReset(
    GetCategoriesReset event,
    Emitter<GetCategoriesState> emit,
  ) {
    emit(GetCategoriesInitial());
  }
}
