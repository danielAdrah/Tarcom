import '../entities/favorites_response_entity.dart';
import '../entities/toggle_favorite_result_entity.dart';

/// عقد عمليات المفضلة.
///
/// - [getFavorites]: جلب مواد المستخدم المفضّلة (تحتاج توثيقاً).
///   المعاملات اختيارية حسب الـ API: `name` (فلترة جزئية بالاسم)
///   و`ordering` (`created_at` | `-created_at`، والافتراضي الأحدث أولاً).
/// - [toggleFavorite]: إضافة المادة للمفضلة إن لم تكن فيها، أو إزالتها إن كانت فيها.
abstract class FavoritesRepository {
  Future<FavoritesResponseEntity> getFavorites({
    String? name,
    String? ordering,
  });

  Future<ToggleFavoriteResultEntity> toggleFavorite({required int materialId});
}
