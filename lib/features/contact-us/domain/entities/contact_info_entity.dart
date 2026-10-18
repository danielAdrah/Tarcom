/// كيان معلومات التواصل الخاصة بالموقع كما ترجعه نقطة `/api/contact/info/`.
///
/// الاستجابة كائن مفرد (Singleton) بالحقول:
/// `{id, phone1, phone2, email, address, created_at, updated_at}`.
class ContactInfoEntity {
  final int id;
  final String phone1;
  final String phone2;
  final String email;
  final String address;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ContactInfoEntity({
    required this.id,
    required this.phone1,
    required this.phone2,
    required this.email,
    required this.address,
    required this.createdAt,
    required this.updatedAt,
  });
}
