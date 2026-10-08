import 'package:get_it/get_it.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../../features/auth/data/repostories/auth_repository_impl.dart';
import '../../features/auth/domain/repostories/auth_repo.dart';
import '../../features/auth/domain/useCases/verify_otp_use_case.dart';
import '../../features/auth/presentation/bloc/sign_up.dart/bloc/sign_up_bloc.dart';
import '../../features/auth/presentation/bloc/verify_otp/bloc/verify_otp_bloc.dart';
import '../api/network/api_client.dart';

import '../../features/auth/data/datasources/auth_remote_data_source.dart';

import '../../features/auth/domain/useCases/sign_up_use_case.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  // =========================================================
  // External
  // =========================================================

  sl.registerLazySingleton<http.Client>(() => http.Client());

  sl.registerLazySingleton<GetStorage>(() => GetStorage());

  // =========================================================
  // Core
  // =========================================================

  sl.registerLazySingleton<ApiClient>(() => ApiClient(sl<http.Client>()));

  //Auth
  initAuth();
}

void initAuth() {
  // =========================================================
  // Auth - Data
  // =========================================================

  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(sl<ApiClient>(), sl<GetStorage>()),
  );

  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(sl<AuthRemoteDataSource>()),
  );

  // =========================================================
  // Auth - Domain
  // =========================================================

  sl.registerLazySingleton<SignUpUseCase>(
    () => SignUpUseCase(sl<AuthRepository>()),
  );

  sl.registerLazySingleton<VerifyOtpUseCase>(
    () => VerifyOtpUseCase(sl<AuthRepository>()),
  );

  // =========================================================
  // Auth - Presentation
  // =========================================================

  sl.registerFactory<SignUpBloc>(() => SignUpBloc(signUpUseCase: sl()));

  sl.registerFactory<VerifyOtpBloc>(
    () => VerifyOtpBloc(verifyOtpUseCase: sl()),
  );
}
