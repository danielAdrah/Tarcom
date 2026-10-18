import '../../../../core/api/errors/api_excptions.dart';
import '../repostories/auth_repo.dart';

/// ينهي جلسة المستخدم: يدرج رمز التحديث في القائمة السوداء ثم يمسح
/// الرموز المخزنة محلياً (يتم المسح داخل طبقة البيانات دائماً).
class LogOutUseCase {
  final AuthRepository repository;

  const LogOutUseCase(this.repository);

  Future<void> call() async {
    try {
      await repository.logout();
    } on ApiException {
      rethrow;
    } catch (_) {
      throw const UnknownApiException();
    }
  }
}
