import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/api/errors/api_excptions.dart';
import '../../../domain/entities/featured_material_entity.dart';
import '../../../domain/entities/featured_materials_response_entity.dart';
import '../../../domain/usecases/get_featured_materials_use_case.dart';

part 'get_featured_materials_event.dart';
part 'get_featured_materials_state.dart';

class GetFeaturedMaterialsBloc
    extends Bloc<GetFeaturedMaterialsEvent, GetFeaturedMaterialsState> {
  final GetFeaturedMaterialsUseCase getFeaturedMaterialsUseCase;

  // تتبع حالة الترقيم بين الأحداث.
  int _pageSize = 10;
  int _currentPage = 1;
  int _count = 0;
  List<FeaturedMaterialEntity> _accumulated = const [];

  GetFeaturedMaterialsBloc({required this.getFeaturedMaterialsUseCase})
    : super(GetFeaturedMaterialsInitial()) {
    on<GetFeaturedMaterialsRequested>(_onGetFeaturedMaterialsRequested);
    on<GetFeaturedMaterialsRefreshRequested>(
      _onGetFeaturedMaterialsRefreshRequested,
    );
    on<GetFeaturedMaterialsLoadMoreRequested>(_onLoadMoreRequested);
    on<GetFeaturedMaterialsReset>(_onGetFeaturedMaterialsReset);
  }

  Future<void> _onGetFeaturedMaterialsRequested(
    GetFeaturedMaterialsRequested event,
    Emitter<GetFeaturedMaterialsState> emit,
  ) async {
    _pageSize = event.pageSize ?? 10;
    await _fetchFirstPage(emit);
  }

  Future<void> _onGetFeaturedMaterialsRefreshRequested(
    GetFeaturedMaterialsRefreshRequested event,
    Emitter<GetFeaturedMaterialsState> emit,
  ) async {
    await _fetchFirstPage(emit);
  }

  Future<void> _fetchFirstPage(Emitter<GetFeaturedMaterialsState> emit) async {
    emit(const GetFeaturedMaterialsLoading());

    try {
      final response = await getFeaturedMaterialsUseCase(
        page: 1,
        pageSize: _pageSize,
      );

      _applyFirstPage(response);
      emit(_successState());
    } on ApiException catch (e) {
      emit(GetFeaturedMaterialsFailure(message: e.message, exception: e));
    } catch (_) {
      emit(
        const GetFeaturedMaterialsFailure(
          message: 'حدث خطأ غير متوقع. حاول مرة أخرى.',
        ),
      );
    }
  }

  Future<void> _onLoadMoreRequested(
    GetFeaturedMaterialsLoadMoreRequested event,
    Emitter<GetFeaturedMaterialsState> emit,
  ) async {
    final current = state;
    if (current is! GetFeaturedMaterialsSuccess ||
        !current.hasMore ||
        current.isLoadingMore) {
      return;
    }

    emit(
      GetFeaturedMaterialsSuccess(
        materials: current.materials,
        count: current.count,
        hasMore: current.hasMore,
        isLoadingMore: true,
      ),
    );

    try {
      final response = await getFeaturedMaterialsUseCase(
        page: _currentPage + 1,
        pageSize: _pageSize,
      );

      _currentPage += 1;
      _accumulated = [..._accumulated, ...response.results];
      _count = response.count;

      emit(_successState());
    } on ApiException catch (e) {
      // الحفاظ على النتائج المعروضة مع إظهار خطأ أسفل الشبكة.
      emit(
        GetFeaturedMaterialsSuccess(
          materials: current.materials,
          count: current.count,
          hasMore: current.hasMore,
          loadMoreError: e.message,
        ),
      );
    } catch (_) {
      emit(
        GetFeaturedMaterialsSuccess(
          materials: current.materials,
          count: current.count,
          hasMore: current.hasMore,
          loadMoreError: 'تعذّر تحميل المزيد. حاول مرة أخرى.',
        ),
      );
    }
  }

  void _applyFirstPage(FeaturedMaterialsResponseEntity response) {
    _currentPage = 1;
    _accumulated = response.results;
    _count = response.count;
  }

  GetFeaturedMaterialsSuccess _successState() {
    return GetFeaturedMaterialsSuccess(
      materials: _accumulated,
      count: _count,
      // نتوقف عندما تصل كل العناصر أو تكون الاستجابة صفحة فارغة.
      hasMore: _accumulated.length < _count && _accumulated.isNotEmpty,
    );
  }

  void _onGetFeaturedMaterialsReset(
    GetFeaturedMaterialsReset event,
    Emitter<GetFeaturedMaterialsState> emit,
  ) {
    _currentPage = 1;
    _accumulated = const [];
    _count = 0;
    emit(GetFeaturedMaterialsInitial());
  }
}
