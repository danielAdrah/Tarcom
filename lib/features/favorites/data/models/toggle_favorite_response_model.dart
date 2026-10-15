import '../../domain/entities/toggle_favorite_result_entity.dart';

class ToggleFavoriteResponseModel extends ToggleFavoriteResultEntity {
  const ToggleFavoriteResponseModel({
    required super.isFavourite,
    required super.message,
  });

  factory ToggleFavoriteResponseModel.fromJson(Map<String, dynamic> json) {
    return ToggleFavoriteResponseModel(
      isFavourite: json['is_favourite'] as bool? ?? false,
      message: json['message'] as String? ?? '',
    );
  }
}
