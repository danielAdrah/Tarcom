import 'package:get_it/get_it.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../../features/auth/data/repostories/auth_repository_impl.dart';
import '../../features/auth/domain/repostories/auth_repo.dart';
import '../../features/auth/domain/useCases/sign_in_use_case.dart';
import '../../features/auth/domain/useCases/verify_otp_use_case.dart';
import '../../features/auth/presentation/bloc/sign_in.dart/bloc/sign_in_bloc.dart';
import '../../features/auth/presentation/bloc/sign_up.dart/bloc/sign_up_bloc.dart';
import '../../features/auth/presentation/bloc/verify_otp/bloc/verify_otp_bloc.dart';
import '../../features/home/data/datasources/featured_materials_remote_data_source.dart';
import '../../features/home/data/repositories/featured_materials_repository_impl.dart';
import '../../features/home/domain/repositories/featured_materials_repository.dart';
import '../../features/home/domain/usecases/get_featured_materials_use_case.dart';
import '../../features/home/presentation/bloc/get_featured_materials/get_featured_materials_bloc.dart';
import '../../features/home/data/datasources/banners_remote_data_source.dart';
import '../../features/home/data/repositories/banners_repository_impl.dart';
import '../../features/home/domain/repositories/banners_repository.dart';
import '../../features/home/domain/usecases/get_banners_use_case.dart';
import '../../features/home/presentation/bloc/get_banners/get_banners_bloc.dart';
import '../../features/favorites/data/datasources/favorites_remote_data_source.dart';
import '../../features/favorites/data/repositories/favorites_repository_impl.dart';
import '../../features/favorites/domain/repositories/favorites_repository.dart';
import '../../features/favorites/domain/usecases/get_favorites_use_case.dart';
import '../../features/favorites/domain/usecases/toggle_favorite_use_case.dart';
import '../../features/favorites/presentation/bloc/favorites/favorites_bloc.dart';
import '../../features/products/data/datasources/categories_remote_data_source.dart';
import '../../features/products/data/datasources/companies_remote_data_source.dart';
import '../../features/products/data/datasources/materials_remote_data_source.dart';
import '../../features/products/data/repositories/categories_repository_impl.dart';
import '../../features/products/data/repositories/companies_repository_impl.dart';
import '../../features/products/data/repositories/materials_repository_impl.dart';
import '../../features/products/domain/repositories/categories_repository.dart';
import '../../features/products/domain/repositories/companies_repository.dart';
import '../../features/products/domain/repositories/materials_repository.dart';
import '../../features/products/domain/usecases/get_categories_use_case.dart';
import '../../features/products/domain/usecases/get_material_companies_use_case.dart';
import '../../features/products/domain/usecases/get_materials_use_case.dart';
import '../../features/products/presentation/bloc/bloc/get_categories_bloc.dart';
import '../../features/products/presentation/bloc/bloc/get_companies_bloc.dart';
import '../../features/products/presentation/bloc/bloc/get_materials_bloc.dart';
import '../../features/search/presentation/cubit/search_cubit.dart';
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

  sl.registerLazySingleton<ApiClient>(
    () => ApiClient(sl<http.Client>(), storage: sl<GetStorage>()),
  );

  //Auth
  initAuth();
  //Categories
  registerCategoriesDependencies();
  //Material companies
  registerCompaniesDependencies();
  //Materials (products) filtered by category & company
  registerMaterialsDependencies();
  //Featured materials
  registerFeaturedMaterialsDependencies();
  //Banners (لافتات الموقع)
  registerBannersDependencies();
  //Favorites (المفضلة)
  registerFavoritesDependencies();
  //Search (البحث الفوري في الرئيسية)
  registerSearchDependencies();
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
  sl.registerLazySingleton<SignInUseCase>(
    () => SignInUseCase(sl<AuthRepository>()),
  );

  // =========================================================
  // Auth - Presentation
  // =========================================================

  sl.registerFactory<SignUpBloc>(() => SignUpBloc(signUpUseCase: sl()));

  sl.registerFactory<VerifyOtpBloc>(
    () => VerifyOtpBloc(verifyOtpUseCase: sl()),
  );
  sl.registerFactory<SignInBloc>(() => SignInBloc(signInUseCase: sl()));
}

void registerCategoriesDependencies() {
  // Remote Data Source
  sl.registerLazySingleton<CategoriesRemoteDataSource>(
    () => CategoriesRemoteDataSourceImpl(apiClient: sl<ApiClient>()),
  );

  // Repository
  sl.registerLazySingleton<CategoriesRepository>(
    () => CategoriesRepositoryImpl(
      remoteDataSource: sl<CategoriesRemoteDataSource>(),
    ),
  );

  // Use Case
  sl.registerLazySingleton<GetCategoriesUseCase>(
    () => GetCategoriesUseCase(sl<CategoriesRepository>()),
  );

  // BLoC
  sl.registerFactory<GetCategoriesBloc>(
    () => GetCategoriesBloc(getCategoriesUseCase: sl<GetCategoriesUseCase>()),
  );
}

void registerCompaniesDependencies() {
  // Remote Data Source
  sl.registerLazySingleton<CompaniesRemoteDataSource>(
    () => CompaniesRemoteDataSourceImpl(apiClient: sl<ApiClient>()),
  );

  // Repository
  sl.registerLazySingleton<CompaniesRepository>(
    () => CompaniesRepositoryImpl(
      remoteDataSource: sl<CompaniesRemoteDataSource>(),
    ),
  );

  // Use Case
  sl.registerLazySingleton<GetMaterialCompaniesUseCase>(
    () => GetMaterialCompaniesUseCase(sl<CompaniesRepository>()),
  );

  // BLoC
  sl.registerFactory<GetCompaniesBloc>(
    () => GetCompaniesBloc(
      getMaterialCompaniesUseCase: sl<GetMaterialCompaniesUseCase>(),
    ),
  );
}

void registerMaterialsDependencies() {
  // Remote Data Source
  sl.registerLazySingleton<MaterialsRemoteDataSource>(
    () => MaterialsRemoteDataSourceImpl(apiClient: sl<ApiClient>()),
  );

  // Repository
  sl.registerLazySingleton<MaterialsRepository>(
    () => MaterialsRepositoryImpl(
      remoteDataSource: sl<MaterialsRemoteDataSource>(),
    ),
  );

  // Use Case
  sl.registerLazySingleton<GetMaterialsUseCase>(
    () => GetMaterialsUseCase(sl<MaterialsRepository>()),
  );

  // BLoC
  sl.registerFactory<GetMaterialsBloc>(
    () => GetMaterialsBloc(getMaterialsUseCase: sl<GetMaterialsUseCase>()),
  );
}

void registerFeaturedMaterialsDependencies() {
  // Remote Data Source
  sl.registerLazySingleton<FeaturedMaterialsRemoteDataSource>(
    () => FeaturedMaterialsRemoteDataSourceImpl(apiClient: sl<ApiClient>()),
  );

  // Repository
  sl.registerLazySingleton<FeaturedMaterialsRepository>(
    () => FeaturedMaterialsRepositoryImpl(
      remoteDataSource: sl<FeaturedMaterialsRemoteDataSource>(),
    ),
  );

  // Use Case
  sl.registerLazySingleton<GetFeaturedMaterialsUseCase>(
    () => GetFeaturedMaterialsUseCase(sl<FeaturedMaterialsRepository>()),
  );

  // BLoC
  sl.registerFactory<GetFeaturedMaterialsBloc>(
    () => GetFeaturedMaterialsBloc(
      getFeaturedMaterialsUseCase: sl<GetFeaturedMaterialsUseCase>(),
    ),
  );
}

void registerBannersDependencies() {
  // Remote Data Source
  sl.registerLazySingleton<BannersRemoteDataSource>(
    () => BannersRemoteDataSourceImpl(apiClient: sl<ApiClient>()),
  );

  // Repository
  sl.registerLazySingleton<BannersRepository>(
    () =>
        BannersRepositoryImpl(remoteDataSource: sl<BannersRemoteDataSource>()),
  );

  // Use Case
  sl.registerLazySingleton<GetBannersUseCase>(
    () => GetBannersUseCase(sl<BannersRepository>()),
  );

  // BLoC
  sl.registerFactory<GetBannersBloc>(
    () => GetBannersBloc(getBannersUseCase: sl<GetBannersUseCase>()),
  );
}

void registerFavoritesDependencies() {
  // Remote Data Source
  sl.registerLazySingleton<FavoritesRemoteDataSource>(
    () => FavoritesRemoteDataSourceImpl(apiClient: sl<ApiClient>()),
  );

  // Repository
  sl.registerLazySingleton<FavoritesRepository>(
    () => FavoritesRepositoryImpl(
      remoteDataSource: sl<FavoritesRemoteDataSource>(),
    ),
  );

  // Use Cases
  sl.registerLazySingleton<GetFavoritesUseCase>(
    () => GetFavoritesUseCase(sl<FavoritesRepository>()),
  );

  sl.registerLazySingleton<ToggleFavoriteUseCase>(
    () => ToggleFavoriteUseCase(sl<FavoritesRepository>()),
  );

  // BLoC
  sl.registerFactory<FavoritesBloc>(
    () => FavoritesBloc(
      getFavoritesUseCase: sl<GetFavoritesUseCase>(),
      toggleFavoriteUseCase: sl<ToggleFavoriteUseCase>(),
    ),
  );
}

void registerSearchDependencies() {
  // SearchCubit: يعيد استخدام GetMaterialsUseCase القائمة (معامل search).
  sl.registerFactory<SearchCubit>(
    () => SearchCubit(getMaterialsUseCase: sl<GetMaterialsUseCase>()),
  );
}
