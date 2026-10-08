import 'package:get_storage/get_storage.dart';

import '../../../../core/api/apiKeys/end_point.dart';
import '../../../../core/api/apiKeys/store_keys.dart';
import '../../../../core/api/network/api_client.dart';
import '../models/sign_in_response_model.dart';
import '../models/sign_up_response_model.dart';
import '../models/verify_otp_response_model.dart';

abstract class AuthRemoteDataSource {
  //in this class we just create the methods without its body
  //the body will be in the implemenation class.
  Future<SignUpResponseModel> signUp({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String phone,
    required String userType,
  });

  //verify method
  Future<VerifyOtpResponseModel> verifyOtp({
    required String email,
    required int code,
    required String codeType,
  });

  //sign in method
  Future<SignInResponseModel> signIn({
    required String email,
    required String password,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient apiClient;
  final GetStorage storage;

  AuthRemoteDataSourceImpl(this.apiClient, this.storage);

  //Sign up method implementation
  @override
  Future<SignUpResponseModel> signUp({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String phone,
    required String userType,
  }) async {
    try {
      final response = await apiClient.post(
        EndPoint.signUp,
        body: {
          'email': email,
          'password': password,
          'first_name': firstName,
          'last_name': lastName,
          'phone': phone,
          'user_type': userType,
        },
        headers: {'Accept-Language': 'ar'},
      );

      return SignUpResponseModel.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  //verify sign up code method implementation
  @override
  Future<VerifyOtpResponseModel> verifyOtp({
    required String email,
    required int code,
    required String codeType,
  }) async {
    try {
      final response = await apiClient.post(
        EndPoint.verifyOtp,
        body: {'email': email, 'code': code, 'code_type': codeType},
        headers: {'Accept-Language': 'ar'},
      );

      final verifyOtpResponse = VerifyOtpResponseModel.fromJson(response);

      // //get the tokens
      // final String accessToken = verifyOtpResponse.tokens.access;
      // final String refreshToken = verifyOtpResponse.tokens.refresh;

      // //store the tokens
      // await storage.write(StorageKeys.accessToken, accessToken);
      // await storage.write(StorageKeys.refreshToken, refreshToken);

      return VerifyOtpResponseModel.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  //sign in method implementation
  @override
  Future<SignInResponseModel> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await apiClient.post(
        EndPoint.signIn,
        body: {'email': email, 'password': password},
        headers: {'Accept-Language': 'ar'},
      );

      final signInResponse = SignInResponseModel.fromJson(response);
      //get the tokens
      final String accessToken = signInResponse.tokens.access;
      final String refreshToken = signInResponse.tokens.refresh;

      print("================ $accessToken");

      //store the tokens
      await storage.write(StorageKeys.accessToken, accessToken);

      await storage.write(StorageKeys.refreshToken, refreshToken);

      return signInResponse;
    } catch (e) {
      rethrow;
    }
  }
}
