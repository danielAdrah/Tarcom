import '../entities/contact_info_entity.dart';

/// عقد جلب معلومات التواصل الخاصة بالموقع.
abstract class ContactInfoRepository {
  Future<ContactInfoEntity> getContactInfo();
}
