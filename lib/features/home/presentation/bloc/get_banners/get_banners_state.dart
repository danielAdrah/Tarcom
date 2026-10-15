part of 'get_banners_bloc.dart';

sealed class GetBannersState extends Equatable {
  const GetBannersState();

  @override
  List<Object> get props => [];
}

final class GetBannersInitial extends GetBannersState {}

/// أثناء تحميل اللافتات.
class GetBannersLoading extends GetBannersState {
  const GetBannersLoading();
}

/// تم جلب اللافتات بنجاح.
class GetBannersSuccess extends GetBannersState {
  final List<BannerEntity> banners;

  const GetBannersSuccess({required this.banners});

  @override
  List<Object> get props => [banners];
}

/// فشل طلب جلب اللافتات.
class GetBannersFailure extends GetBannersState {
  final String message;
  final ApiException? exception;

  const GetBannersFailure({required this.message, this.exception});

  @override
  List<Object> get props => [message, ?exception];
}
