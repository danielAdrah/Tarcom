part of 'get_banners_bloc.dart';

sealed class GetBannersEvent extends Equatable {
  const GetBannersEvent();

  @override
  List<Object> get props => [];
}

/// جلب لافتات الموقع لأول مرة أو إعادة المحاولة بعد الفشل.
class GetBannersRequested extends GetBannersEvent {
  const GetBannersRequested();
}

/// إعادة جلب اللافتات، مثلاً عند السحب للتحديث.
class GetBannersRefreshRequested extends GetBannersEvent {
  const GetBannersRefreshRequested();
}

/// إعادة الحالة إلى Initial.
class GetBannersReset extends GetBannersEvent {
  const GetBannersReset();
}
