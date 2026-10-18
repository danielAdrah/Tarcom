import 'dart:async';

import 'package:get_storage/get_storage.dart';

import '../api/apiKeys/store_keys.dart';

/// نقطة واحدة لإنهاء الجلسة عند فشل تحديث رمز الوصول.
///
/// يستدعي `ApiClient` الدالة [onSessionExpired] عند استقبال 401 وفشل
/// `auth/token/refresh/`، فيتم مسح الرموز من المخزن المحلي وإشعار الطبقة
/// التقديمية (في `main.dart`) للوجه الإجباري إلى صفحة تسجيل الدخول.
/// هكذا تُحل المشكلة في كل الطلبات وليس عند بدء التشغيل فقط.
class SessionController {
  final GetStorage storage;

  /// بثّ متعددة المستمعين حتى لا يلغي أي اشتراك الاشتراكات الأخرى.
  final StreamController<String> _expiredController =
      StreamController<String>.broadcast();

  SessionController(this.storage);

  /// رسائل بالعربية تخص انتهاء الجلسة، تُعرض للمستخدم عند الإخراج القسري.
  static const String expiredMessage =
      'انتهت صلاحية الجلسة، يرجى تسجيل الدخول من جديد.';

  Stream<String> get onExpired => _expiredController.stream;

  /// يُستدعى عندما يعيد الخادم 401 ويفشل تحديث رمز الوصول. يمسح الرموز
  /// المخزنة محلياً ثم يبثّ حدث انتهاء الجلسة للطبقة التقديمية.
  void handleForcedLogout() {
    _clearLocalSession();
    _expiredController.add(expiredMessage);
  }

  void _clearLocalSession() {
    storage.remove(StorageKeys.accessToken);
    storage.remove(StorageKeys.refreshToken);
  }
}
