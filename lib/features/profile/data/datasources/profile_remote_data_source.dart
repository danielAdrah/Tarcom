import '../../../../core/api/apiKeys/end_point.dart';
import '../../../../core/api/network/api_client.dart';
import '../../domain/entities/update_profile_params.dart';
import '../models/user_profile_model.dart';

abstract class ProfileRemoteDataSource {
  Future<UserProfileModel> getUserProfile();

  Future<UserProfileModel> updateUserProfile(UpdateProfileParams params);
}

//==-=-=-=-=-=-=-=-=-=-==

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final ApiClient apiClient;

  const ProfileRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<UserProfileModel> getUserProfile() async {
    // `Authorization: Bearer` تُحقن تلقائياً داخل ApiClient من GetStorage.
    final response = await apiClient.get(
      EndPoint.getUserProfile,
      headers: {'Accept-Language': 'ar'},
    );

    return UserProfileModel.fromJson(response);
  }

  @override
  Future<UserProfileModel> updateUserProfile(UpdateProfileParams params) async {
    // PUT كامل: first_name / last_name / phone (الترويسات والرمز يُحقنان تلقائياً).
    final response = await apiClient.put(
      EndPoint.updateUserProfile,
      body: {
        'first_name': params.firstName,
        'last_name': params.lastName,
        'phone': params.phone,
      },
      headers: {'Accept-Language': 'ar'},
    );

    return UserProfileModel.fromJson(response);
  }
}
