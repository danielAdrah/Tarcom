import '../../domain/entities/favorite_material_entity.dart';
import '../../domain/entities/favorites_response_entity.dart';
import 'favorite_material_model.dart';

class FavoritesResponseModel extends FavoritesResponseEntity {
  const FavoritesResponseModel({
    required super.count,
    required super.next,
    required super.previous,
    required super.results,
  });

  factory FavoritesResponseModel.fromJson(Map<String, dynamic> json) {
    final resultsJson = json['results'] as List<dynamic>? ?? [];

    return FavoritesResponseModel(
      count: (json['count'] as num?)?.toInt() ?? 0,
      next: json['next'] as String?,
      previous: json['previous'] as String?,
      results: resultsJson
          .map(
            (item) => FavoriteMaterialModel.fromJson(item as Map<String, dynamic>),
          )
          .toList()
          .cast<FavoriteMaterialEntity>(),
    );
  }
}
