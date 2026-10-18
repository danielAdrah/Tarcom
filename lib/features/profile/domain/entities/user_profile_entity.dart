/// كيان الملف الشخصي للمستخدم الموثّق كما ترجعه نقطة `/api/users/me/`.
///
/// الاستجابة: `{id, email, first_name, last_name, phone, avatar, user_type}`.
class UserProfileEntity {
  final int id;
  final String email;
  final String firstName;
  final String lastName;
  final String phone;
  final String? avatar;
  final String userType;

  const UserProfileEntity({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.phone,
    this.avatar,
    required this.userType,
  });

  /// الاسم الكامل كما يظهر في الواجهة.
  String get fullName => '$firstName $lastName'.trim();

  /// الأحرف الأولى المستخدمة كبديل للصورة عند غياب الـ avatar.
  String get initials {
    final String first = firstName.isNotEmpty ? firstName[0] : '';
    final String last = lastName.isNotEmpty ? lastName[0] : '';
    return '$first$last'.trim();
  }

  /// نسبة اكتمال الملف الشخصي: الاسم والهاتف والبريد.
  /// (الصورة الشخصية غير مدعومة حالياً فلا تدخل في الاحتساب.)
  double get completeness {
    int filled = 0;
    if (fullName.isNotEmpty) filled++;
    if (phone.isNotEmpty) filled++;
    if (email.isNotEmpty) filled++;
    return filled / 3;
  }

  /// تسمية نوع المستخدم بالعربية للشارة (badge) في الواجهة.
  String get userTypeLabel {
    switch (userType) {
      case 'seller':
        return 'بائع';
      case 'admin':
        return 'مدير';
      case 'customer':
      default:
        return 'عميل';
    }
  }
}
