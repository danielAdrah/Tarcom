import 'package:get_storage/get_storage.dart';

import '../../../../core/api/apiKeys/end_point.dart';
import '../../../../core/api/apiKeys/store_keys.dart';
import '../../../../core/api/errors/api_excptions.dart';
import '../../../../core/api/network/api_client.dart';
import '../models/auth_tokens_model.dart';
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

  //log out method: blacklist the refresh token then clear the local session
  Future<void> logout();

  //refresh method: exchange the stored refresh token for a new access token
  Future<AuthTokensModel> refreshToken();
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

      late final SignInResponseModel signInResponse;
      try {
        signInResponse = SignInResponseModel.fromJson(response);
      } catch (_) {
        rethrow;
      }
      //get the tokens
      final String accessToken = signInResponse.tokens.access;
      final String refreshToken = signInResponse.tokens.refresh;

      //store the tokens
      await storage.write(StorageKeys.accessToken, accessToken);

      await storage.write(StorageKeys.refreshToken, refreshToken);

      return signInResponse;
    } catch (e) {
      rethrow;
    }
  }

  //refresh method implementation
  @override
  Future<AuthTokensModel> refreshToken() async {
    // نقرأ رمز التحديث المخزّن لتبادل رمز وصول جديد به.
    final String refreshToken =
        storage.read<String>(StorageKeys.refreshToken) ?? '';

    if (refreshToken.isEmpty) {
      throw UnauthorizedException(message: 'لا توجد جلسة قابلة للتحديث.');
    }

    // الطلب يمر عبر ApiClient؛ عند إعادة 401 (رمز التحديث منتهي) لن يحاول
    // ApiClient التحديث مرة أخرى بفضل حارس _isRefreshing، فيُرمى الاستثناء
    // إلى الأعلى لتعالجه الطبقة التقديمية بإخراج المستخدم قسراً.
    final response = await apiClient.post(
      EndPoint.refreshToken,
      body: {'refresh': refreshToken},
      headers: {'Accept-Language': 'ar'},
    );

    final AuthTokensModel tokens = AuthTokensModel.fromJson(response);

    // نخزّن رمز الوصول الجديد دائماً، ورمز التحديث الجديد فقط إذا أعاده
    // الخادم (بعض الإعدادات لا تدوّر رمز التحديث).
    await storage.write(StorageKeys.accessToken, tokens.access);
    if (tokens.refresh.isNotEmpty) {
      await storage.write(StorageKeys.refreshToken, tokens.refresh);
    }

    return tokens;
  }

  //log out method implementation
  @override
  Future<void> logout() async {
    // نقرأ رمز التحديث من المخزن المحلي لمحاولة إدراجه في القائمة السوداء.
    final String refreshToken =
        storage.read<String>(StorageKeys.refreshToken) ?? '';

    try {
      if (refreshToken.isNotEmpty) {
        await apiClient.post(
          EndPoint.logout,
          body: {'refresh': refreshToken},
          headers: {'Accept-Language': 'ar'},
        );
      }
    } finally {
      // نمسح الجلسة المحلية دائماً لضمان إنهاء دخول المستخدم حتى لو فشل
      // إدراج الرمز في القائمة السوداء (انقطاع شبكة أو رمز منتهي الصلاحية).
      await storage.remove(StorageKeys.accessToken);
      await storage.remove(StorageKeys.refreshToken);
    }
  }
}
