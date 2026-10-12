import 'featured_material_entity.dart';

class FeaturedMaterialsResponseEntity {
  final int count;
  final String? next;
  final String? previous;
  final List<FeaturedMaterialEntity> results;

  const FeaturedMaterialsResponseEntity({
    required this.count,
    required this.next,
    required this.previous,
    required this.results,
  });
}
