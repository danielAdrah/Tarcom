part of 'get_contact_info_bloc.dart';

sealed class GetContactInfoEvent extends Equatable {
  const GetContactInfoEvent();

  @override
  List<Object> get props => [];
}

/// جلب معلومات التواصل لأول مرة أو إعادة المحاولة بعد الفشل.
class GetContactInfoRequested extends GetContactInfoEvent {
  const GetContactInfoRequested();
}

/// إعادة جلب معلومات التواصل، مثلاً عند السحب للتحديث.
class GetContactInfoRefreshRequested extends GetContactInfoEvent {
  const GetContactInfoRefreshRequested();
}
