import '../../domain/entities/categories_response_entity.dart';
import '../../domain/repositories/categories_repository.dart';
import '../datasources/categories_remote_data_source.dart';

class CategoriesRepositoryImpl implements CategoriesRepository {
  final CategoriesRemoteDataSource remoteDataSource;

  const CategoriesRepositoryImpl({required this.remoteDataSource});

  @override
  Future<CategoriesResponseEntity> getCategories() async {
    return await remoteDataSource.getCategories();
  }
}
