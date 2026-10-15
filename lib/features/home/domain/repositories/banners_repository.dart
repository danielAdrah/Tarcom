import '../entities/banner_entity.dart';

/// عقد جلب لافتات الموقع النشطة.
abstract class BannersRepository {
  Future<List<BannerEntity>> getBanners();
}
