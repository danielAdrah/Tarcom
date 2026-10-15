import '../../domain/entities/material_entity.dart';
import '../../domain/entities/materials_response_entity.dart';
import 'material_model.dart';

class MaterialsResponseModel extends MaterialsResponseEntity {
  const MaterialsResponseModel({
    required super.count,
    required super.next,
    required super.previous,
    required super.results,
  });

  factory MaterialsResponseModel.fromJson(Map<String, dynamic> json) {
    final resultsJson = json['results'] as List<dynamic>? ?? [];

    return MaterialsResponseModel(
      count: json['count'] as int? ?? 0,
      next: json['next'] as String?,
      previous: json['previous'] as String?,
      results: resultsJson
          .map((item) => MaterialModel.fromJson(item as Map<String, dynamic>))
          .toList()
          .cast<MaterialEntity>(),
    );
  }
}
