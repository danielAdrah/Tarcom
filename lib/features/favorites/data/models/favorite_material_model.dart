import '../../domain/entities/favorite_material_entity.dart';
import 'material_detail_model.dart';

class FavoriteMaterialModel extends FavoriteMaterialEntity {
  const FavoriteMaterialModel({
    required super.id,
    required super.materialId,
    required super.materialDetail,
    required super.createdAt,
  });

  factory FavoriteMaterialModel.fromJson(Map<String, dynamic> json) {
    final detailJson = json['material_detail'];

    return FavoriteMaterialModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      materialId: (json['material'] as num?)?.toInt() ?? 0,
      // `material_detail` كائن متداخل؛ نهمل العنصر إذا غاب بتفاصيل فارغة آمنة.
      materialDetail: detailJson is Map<String, dynamic>
          ? MaterialDetailModel.fromJson(detailJson)
          : const MaterialDetailModel(
              id: 0,
              name: '',
              consumerPrice: 0,
              supplierPrice: 0,
              isActive: false,
              image1: null,
              category: null,
              categoryName: '',
              uom: null,
              uomName: '',
            ),
      createdAt:
          DateTime.tryParse(json['created_at'] as String? ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0),
    );
  }
}
