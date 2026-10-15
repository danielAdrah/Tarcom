import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/api/errors/api_excptions.dart';
import '../../../domain/entities/banner_entity.dart';
import '../../../domain/usecases/get_banners_use_case.dart';

part 'get_banners_event.dart';
part 'get_banners_state.dart';

class GetBannersBloc extends Bloc<GetBannersEvent, GetBannersState> {
  final GetBannersUseCase getBannersUseCase;

  GetBannersBloc({required this.getBannersUseCase})
    : super(GetBannersInitial()) {
    on<GetBannersRequested>(_onFetchBanners);
    on<GetBannersRefreshRequested>(_onFetchBanners);
    on<GetBannersReset>(_onGetBannersReset);
  }

  Future<void> _onFetchBanners(
    GetBannersEvent event,
    Emitter<GetBannersState> emit,
  ) async {
    emit(const GetBannersLoading());

    try {
      final banners = await getBannersUseCase();

      // نعرض اللافتات النشطة فقط، مرتّبة حسب الأحدث تحديثاً.
      final active = banners.where((banner) => banner.isActive).toList()
        ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));

      emit(GetBannersSuccess(banners: active));
    } on ApiException catch (e) {
      emit(GetBannersFailure(message: e.message, exception: e));
    } catch (_) {
      emit(
        const GetBannersFailure(message: 'حدث خطأ غير متوقع. حاول مرة أخرى.'),
      );
    }
  }

  void _onGetBannersReset(
    GetBannersReset event,
    Emitter<GetBannersState> emit,
  ) {
    emit(GetBannersInitial());
  }
}
