import 'favorite_material_entity.dart';

/// استجابة الترقيم لقائمة المفضلة (`count` / `next` / `previous` / `results`).
class FavoritesResponseEntity {
  final int count;
  final String? next;
  final String? previous;
  final List<FavoriteMaterialEntity> results;

  const FavoritesResponseEntity({
    required this.count,
    required this.next,
    required this.previous,
    required this.results,
  });
}
