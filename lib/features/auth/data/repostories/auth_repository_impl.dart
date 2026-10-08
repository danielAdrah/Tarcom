import 'package:tarcom/features/auth/domain/entities/verify_otp_response_entity.dart';

import '../../domain/entities/sign_in_response_entity.dart';
import '../../domain/entities/sign_up_entity.dart';
import '../../domain/repostories/auth_repo.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<SignUpEntity> signUp({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String phone,
    required String userType,
  }) async {
    try {
      return await remoteDataSource.signUp(
        email: email,
        password: password,
        firstName: firstName,
        lastName: lastName,
        phone: phone,
        userType: userType,
      );
    } catch (e) {
      rethrow;
    }
  }
  //method verfiy sign up code

  @override
  Future<VerifyOtpResponseEntity> verifyOtp({
    required String email,
    required int code,
    required String codeType,
  }) async {
    try {
      return await remoteDataSource.verifyOtp(
        email: email,
        code: code,
        codeType: codeType,
      );
    } catch (e) {
      rethrow;
    }
  }

  //method sign in

  @override
  Future<SignInResponseEntity> signIn({
    required String email,
    required String password,
  }) async {
    try {
      return await remoteDataSource.signIn(email: email, password: password);
    } catch (e) {
      rethrow;
    }
  }
}
