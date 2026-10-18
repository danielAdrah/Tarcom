import '../../../../core/api/errors/api_excptions.dart';
import '../entities/auth_tokens_entity.dart';
import '../repostories/auth_repo.dart';

/// يحدّث رمز الوصول باستخدام رمز التحديث المخزّن. تُحدَّث الرموز في المخزن
/// المحلي داخل طبقة البيانات، لذا لا حاجة لتمرير أي معاملات.
class RefreshTokenUseCase {
  final AuthRepository repository;

  const RefreshTokenUseCase(this.repository);

  Future<AuthTokensEntity> call() async {
    try {
      return await repository.refreshToken();
    } on ApiException {
      rethrow;
    } catch (_) {
      throw const UnknownApiException();
    }
  }
}
