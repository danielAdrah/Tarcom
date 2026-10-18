import '../models/contact_info_model.dart';

import '../../../../core/api/network/api_client.dart';
import '../../../../core/api/apiKeys/end_point.dart';

abstract class ContactInfoRemoteDataSource {
  Future<ContactInfoModel> getContactInfo();
}

//==-=-=-=-=-=-=-=-=-=-==

class ContactInfoRemoteDataSourceImpl implements ContactInfoRemoteDataSource {
  final ApiClient apiClient;

  const ContactInfoRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<ContactInfoModel> getContactInfo() async {
    // الاستجابة كائن JSON مفرد غير منطّق (Singleton).
    final response = await apiClient.get(
      EndPoint.getContactInfo,
      headers: {'Accept-Language': 'ar'},
    );

    return ContactInfoModel.fromJson(response);
  }
}
