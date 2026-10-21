import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/api/errors/api_excptions.dart';
import '../../../domain/entities/company_entity.dart';
import '../../../domain/usecases/get_material_companies_use_case.dart';

part 'get_companies_event.dart';
part 'get_companies_state.dart';

class GetCompaniesBloc extends Bloc<GetCompaniesEvent, GetCompaniesState> {
  final GetMaterialCompaniesUseCase getMaterialCompaniesUseCase;

  GetCompaniesBloc({required this.getMaterialCompaniesUseCase})
    : super(GetCompaniesInitial()) {
    on<GetCompaniesRequested>(_onFetchCompanies);
    on<GetCompaniesRefreshRequested>(_onFetchCompanies);
    on<GetCompaniesReset>(_onGetCompaniesReset);
  }

  Future<void> _onFetchCompanies(
    GetCompaniesEvent event,
    Emitter<GetCompaniesState> emit,
  ) async {
    emit(const GetCompaniesLoading());

    try {
      final companies = await getMaterialCompaniesUseCase(
        categoryId: event.categoryId,
        isActive: event.isActive,
        categoryInternalName: event.categoryInternalName,
      );

      emit(GetCompaniesSuccess(companies: companies));
    } on ApiException catch (e) {
      emit(GetCompaniesFailure(message: e.message, exception: e));
    } catch (_) {
      emit(
        const GetCompaniesFailure(message: 'حدث خطأ غير متوقع. حاول مرة أخرى.'),
      );
    }
  }

  void _onGetCompaniesReset(
    GetCompaniesReset event,
    Emitter<GetCompaniesState> emit,
  ) {
    emit(GetCompaniesInitial());
  }
}
