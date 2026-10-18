import 'dart:developer' as developer;

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/api/errors/api_excptions.dart';
import '../../../domain/entities/material_entity.dart';
import '../../../domain/entities/materials_response_entity.dart';
import '../../../domain/usecases/get_materials_use_case.dart';

part 'get_materials_event.dart';
part 'get_materials_state.dart';

/// اسم موحّد لسجلات الترقيم (يصفّى عبر `flutter logs --name=Pagination`).
const String _paginationLog = 'Pagination';

/// BLoC جلب المواد (المنتجات) المفلترة حسب الفئة والشركة، مع بحث وترقيم غير منتهي.
class GetMaterialsBloc extends Bloc<GetMaterialsEvent, GetMaterialsState> {
  final GetMaterialsUseCase getMaterialsUseCase;

  // حفظ معاملات الفلترة والترقيم بين الأحداث (refresh / loadMore).
  _MaterialsFilter _filter = const _MaterialsFilter();
  int _pageSize = 10;
  int _currentPage = 1;
  int _count = 0;
  List<MaterialEntity> _accumulated = const [];

  GetMaterialsBloc({required this.getMaterialsUseCase})
    : super(GetMaterialsInitial()) {
    on<GetMaterialsRequested>(_onRequested);
    on<GetMaterialsRefreshRequested>(_onRefreshRequested);
    on<GetMaterialsLoadMoreRequested>(_onLoadMoreRequested);
    on<GetMaterialsReset>(_onReset);
  }

  Future<void> _onRequested(
    GetMaterialsRequested event,
    Emitter<GetMaterialsState> emit,
  ) async {
    _filter = event._toFilter();
    _pageSize = event.pageSize ?? 10;
    await _fetchFirstPage(emit);
  }

  Future<void> _onRefreshRequested(
    GetMaterialsRefreshRequested event,
    Emitter<GetMaterialsState> emit,
  ) async {
    await _fetchFirstPage(emit);
  }

  Future<void> _fetchFirstPage(Emitter<GetMaterialsState> emit) async {
    developer.log(
      'BLOC     fetch page=1 (category=${_filter.category} company=${_filter.company} '
      'search="${_filter.search}" page_size=$_pageSize)',
      name: _paginationLog,
    );
    emit(const GetMaterialsLoading());

    try {
      final response = await _fetch(page: 1);
      _currentPage = 1;
      _accumulated = response.results;
      _count = response.count;
      final success = _successState();
      developer.log(
        'BLOC     page=1 OK: added=${response.results.length} '
        'accumulated=${_accumulated.length}/$_count hasMore=${success.hasMore}',
        name: _paginationLog,
      );
      emit(success);
    } on ApiException catch (e) {
      developer.log(
        'BLOC     page=1 FAILED: ${e.message}',
        name: _paginationLog,
        error: e,
      );
      emit(GetMaterialsFailure(message: e.message, exception: e));
    } catch (error) {
      developer.log(
        'BLOC     page=1 UNEXPECTED: ${error.runtimeType}',
        name: _paginationLog,
        error: error,
      );
      emit(
        const GetMaterialsFailure(message: 'حدث خطأ غير متوقع. حاول مرة أخرى.'),
      );
    }
  }

  Future<void> _onLoadMoreRequested(
    GetMaterialsLoadMoreRequested event,
    Emitter<GetMaterialsState> emit,
  ) async {
    final current = state;
    if (current is! GetMaterialsSuccess ||
        !current.hasMore ||
        current.isLoadingMore) {
      final success = current is GetMaterialsSuccess ? current : null;
      developer.log(
        'BLOC     loadMore IGNORED: state=${current.runtimeType} '
        'hasMore=${success?.hasMore} isLoadingMore=${success?.isLoadingMore} '
        'accumulated=${success?.materials.length ?? _accumulated.length}',
        name: _paginationLog,
      );
      return;
    }

    final nextPage = _currentPage + 1;
    developer.log(
      'BLOC     loadMore START: page=$nextPage '
      '(accumulated=${_accumulated.length}/$_count)',
      name: _paginationLog,
    );

    emit(
      GetMaterialsSuccess(
        materials: current.materials,
        count: current.count,
        hasMore: current.hasMore,
        isLoadingMore: true,
      ),
    );

    try {
      final response = await _fetch(page: nextPage);

      _currentPage = nextPage;
      _accumulated = [..._accumulated, ...response.results];
      _count = response.count;

      final success = _successState();
      developer.log(
        'BLOC     loadMore DONE: page=$nextPage added=${response.results.length} '
        'accumulated=${_accumulated.length}/$_count hasMore=${success.hasMore}',
        name: _paginationLog,
      );
      emit(success);
    } on ApiException catch (e) {
      developer.log(
        'BLOC     loadMore FAILED: page=$nextPage ${e.message}',
        name: _paginationLog,
        error: e,
      );
      // الحفاظ على النتائج المعروضة مع إظهار خطأ أسفل الشبكة.
      emit(
        GetMaterialsSuccess(
          materials: current.materials,
          count: current.count,
          hasMore: current.hasMore,
          loadMoreError: e.message,
        ),
      );
    } catch (error) {
      developer.log(
        'BLOC     loadMore UNEXPECTED: page=$nextPage ${error.runtimeType}',
        name: _paginationLog,
        error: error,
      );
      emit(
        GetMaterialsSuccess(
          materials: current.materials,
          count: current.count,
          hasMore: current.hasMore,
          loadMoreError: 'تعذّر تحميل المزيد. حاول مرة أخرى.',
        ),
      );
    }
  }

  Future<MaterialsResponseEntity> _fetch({required int page}) {
    final filter = _filter;
    return getMaterialsUseCase(
      category: filter.category,
      company: filter.company,
      companyName: filter.companyName,
      isActive: filter.isActive,
      search: filter.search,
      ordering: filter.ordering,
      specKey1: filter.specKey1,
      specKey2: filter.specKey2,
      specKey3: filter.specKey3,
      specKey4: filter.specKey4,
      specKey5: filter.specKey5,
      specVal1: filter.specVal1,
      specVal2: filter.specVal2,
      specVal3: filter.specVal3,
      specVal4: filter.specVal4,
      specVal5: filter.specVal5,
      page: page,
      pageSize: _pageSize,
    );
  }

  GetMaterialsSuccess _successState() {
    return GetMaterialsSuccess(
      materials: _accumulated,
      count: _count,
      // نتوقف عندما تصل كل العناصر أو تكون الاستجابة صفحة فارغة.
      hasMore: _accumulated.length < _count && _accumulated.isNotEmpty,
    );
  }

  void _onReset(GetMaterialsReset event, Emitter<GetMaterialsState> emit) {
    _filter = const _MaterialsFilter();
    _currentPage = 1;
    _accumulated = const [];
    _count = 0;
    emit(GetMaterialsInitial());
  }
}
