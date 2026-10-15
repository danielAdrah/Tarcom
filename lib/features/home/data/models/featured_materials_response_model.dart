import '../../domain/entities/featured_material_entity.dart';
import '../../domain/entities/featured_materials_response_entity.dart';
import 'featured_material_model.dart';

class FeaturedMaterialsResponseModel extends FeaturedMaterialsResponseEntity {
  const FeaturedMaterialsResponseModel({
    required super.count,
    required super.next,
    required super.previous,
    required super.results,
  });

  factory FeaturedMaterialsResponseModel.fromJson(Map<String, dynamic> json) {
    final resultsJson = json['results'] as List<dynamic>? ?? [];

    return FeaturedMaterialsResponseModel(
      count: json['count'] as int? ?? 0,
      next: json['next'] as String?,
      previous: json['previous'] as String?,
      results: resultsJson
          .map(
            (item) =>
                FeaturedMaterialModel.fromJson(item as Map<String, dynamic>),
          )
          .toList()
          .cast<FeaturedMaterialEntity>(),
    );
  }
}
