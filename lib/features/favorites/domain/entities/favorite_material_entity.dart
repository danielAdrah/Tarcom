import 'material_detail_entity.dart';

/// عنصر مفضلة واحد كما يرجعه `GET /api/favourites/`.
///
/// يربط سجل المفضلة (`id`) بالمادة المُفضَّلة (`material`) وتفاصيلها الكاملة.
class FavoriteMaterialEntity {
  final int id;
  final int materialId;
  final MaterialDetailEntity materialDetail;
  final DateTime createdAt;

  const FavoriteMaterialEntity({
    required this.id,
    required this.materialId,
    required this.materialDetail,
    required this.createdAt,
  });
}
