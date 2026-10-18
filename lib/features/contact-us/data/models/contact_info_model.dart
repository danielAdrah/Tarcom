import '../../domain/entities/contact_info_entity.dart';

class ContactInfoModel extends ContactInfoEntity {
  const ContactInfoModel({
    required super.id,
    required super.phone1,
    required super.phone2,
    required super.email,
    required super.address,
    required super.createdAt,
    required super.updatedAt,
  });

  factory ContactInfoModel.fromJson(Map<String, dynamic> json) {
    return ContactInfoModel(
      id: json['id'] as int? ?? 0,
      phone1: json['phone1'] as String? ?? '',
      phone2: json['phone2'] as String? ?? '',
      email: json['email'] as String? ?? '',
      address: json['address'] as String? ?? '',
      createdAt:
          DateTime.tryParse(json['created_at'] as String? ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0),
      updatedAt:
          DateTime.tryParse(json['updated_at'] as String? ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0),
    );
  }
}
