import '../../domain/entities/contact_info_entity.dart';
import '../../domain/repositories/contact_info_repository.dart';
import '../datasources/contact_info_remote_data_source.dart';

class ContactInfoRepositoryImpl implements ContactInfoRepository {
  final ContactInfoRemoteDataSource remoteDataSource;

  const ContactInfoRepositoryImpl({required this.remoteDataSource});

  @override
  Future<ContactInfoEntity> getContactInfo() async {
    return await remoteDataSource.getContactInfo();
  }
}
