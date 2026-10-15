import 'material_entity.dart';

/// استجابة منطّقة لقائمة المواد (`/api/materials/`) بترقيم DRF القياسي.
class MaterialsResponseEntity {
  final int count;
  final String? next;
  final String? previous;
  final List<MaterialEntity> results;

  const MaterialsResponseEntity({
    required this.count,
    required this.next,
    required this.previous,
    required this.results,
  });
}
