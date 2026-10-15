import '../../domain/entities/company_detail_entity.dart';

class CompanyDetailModel extends CompanyDetailEntity {
  const CompanyDetailModel({
    required super.id,
    required super.name,
    required super.logo,
  });

  factory CompanyDetailModel.fromJson(Map<String, dynamic> json) {
    return CompanyDetailModel(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      logo: json['logo'] as String? ?? '',
    );
  }
}
