import 'dart:developer' as developer;

import '../../../../core/api/apiKeys/end_point.dart';
import '../../../../core/api/network/api_client.dart';
import '../models/materials_response_model.dart';

/// اسم موحّد لسجلات الترقيم، لسهولة تصفيتها عبر `flutter logs`.
const String _paginationLog = 'Pagination';

abstract class MaterialsRemoteDataSource {
  Future<MaterialsResponseModel> getMaterials({
    required int? category,
    required int? company,
    String? companyName,
    bool? isActive,
    String? search,
    String? ordering,
    String? specKey1,
    String? specKey2,
    String? specKey3,
    String? specKey4,
    String? specKey5,
    String? specVal1,
    String? specVal2,
    String? specVal3,
    String? specVal4,
    String? specVal5,
    int? page,
    int? pageSize,
  });
}

//==-=-=-=-=-=-=-=-=-=-==

class MaterialsRemoteDataSourceImpl implements MaterialsRemoteDataSource {
  final ApiClient apiClient;

  const MaterialsRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<MaterialsResponseModel> getMaterials({
    required int? category,
    required int? company,
    String? companyName,
    bool? isActive,
    String? search,
    String? ordering,
    String? specKey1,
    String? specKey2,
    String? specKey3,
    String? specKey4,
    String? specKey5,
    String? specVal1,
    String? specVal2,
    String? specVal3,
    String? specVal4,
    String? specVal5,
    int? page,
    int? pageSize,
  }) async {
    // `category` و`company` إلزاميان، وبقية المعاملات اختيارية؛ نمرّر غير الفارغة فقط.
    final queryParameters = <String, dynamic>{
      'category': ?category,
      'company': ?company,
      if (companyName != null && companyName.isNotEmpty)
        'company_name': companyName,
      'is_active': ?isActive,
      if (search != null && search.isNotEmpty) 'search': search,
      if (ordering != null && ordering.isNotEmpty) 'ordering': ordering,
      if (specKey1 != null && specKey1.isNotEmpty) 'spec_key1': specKey1,
      if (specKey2 != null && specKey2.isNotEmpty) 'spec_key2': specKey2,
      if (specKey3 != null && specKey3.isNotEmpty) 'spec_key3': specKey3,
      if (specKey4 != null && specKey4.isNotEmpty) 'spec_key4': specKey4,
      if (specKey5 != null && specKey5.isNotEmpty) 'spec_key5': specKey5,
      if (specVal1 != null && specVal1.isNotEmpty) 'spec_val1': specVal1,
      if (specVal2 != null && specVal2.isNotEmpty) 'spec_val2': specVal2,
      if (specVal3 != null && specVal3.isNotEmpty) 'spec_val3': specVal3,
      if (specVal4 != null && specVal4.isNotEmpty) 'spec_val4': specVal4,
      if (specVal5 != null && specVal5.isNotEmpty) 'spec_val5': specVal5,
      'page': ?page,
      'page_size': ?pageSize,
    };

    //==-=-=-=-=-= سجلات الترقيم: الطلب الصادر ومعاملاته.
    developer.log(
      'REQUEST  -> page=$page page_size=$pageSize params=$queryParameters',
      name: _paginationLog,
    );

    final response = await apiClient.get(
      EndPoint.getMaterials,
      queryParameters: queryParameters,
      headers: {'Accept-Language': 'ar'},
    );

    final model = MaterialsResponseModel.fromJson(response);

    final nextLabel = model.next == null ? 'null' : 'PRESENT';
    final previousLabel = model.previous == null ? 'null' : 'PRESENT';

    //==-=-=-=-=-= سجلات الترقيم: الاستجابة الواردة وغلاف الترقيم.
    developer.log(
      'RESPONSE <- page=$page count=${model.count} '
      'results=${model.results.length} '
      'next=$nextLabel previous=$previousLabel',
      name: _paginationLog,
    );

    // الخادم تجاهل `page_size`؟ (يدلّل على أن الترقيم غير فعّال من الجهة الخدمية).
    if (pageSize != null && model.results.length > pageSize) {
      developer.log(
        'WARNING  page_size IGNORED by API: asked=$pageSize got=${model.results.length}',
        name: _paginationLog,
      );
    }

    // `count` أكبر من المعروض مع `next == null` → احتمال تحميل لا ينتهي.
    if (model.next == null && model.results.isNotEmpty) {
      final size = pageSize ?? model.results.length;
      final expectedPages = (model.count / size).ceil();
      developer.log(
        'LAST PAGE  next=null with count=${model.count}; '
        'at page_size=$size that is ~$expectedPages page(s)',
        name: _paginationLog,
      );
    }

    return model;
  }
}
