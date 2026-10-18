class EndPoint {
  EndPoint._();

  static const String baseUrl = 'https://rabee371.pythonanywhere.com/api/';

  static const String signUp = 'auth/signup/';
  static const String signIn = 'auth/login/';
  static const String logout = 'auth/logout/';
  static const String refreshToken = 'auth/token/refresh/';
  static const String verifyOtp = 'auth/verify-otp/';
  static const String getCategories = 'categories/';
  static const String getFeaturedMaterials = 'features/';
  static const String getMaterialCompanies = 'materials/companies/';
  static const String getMaterials = 'materials/';

  // Favourites (المفضلة)
  static const String getFavorites = 'favourites/';
  static const String toggleFavorite = 'favourites/toggle/';

  // Banners (لافتات الموقع)
  static const String getBanners = 'banners/';

  // Contact (معلومات التواصل)
  static const String getContactInfo = 'contact/info/';

  // Profile (الملف الشخصي للمستخدم الموثّق)
  static const String getUserProfile = 'users/me/';
  static const String updateUserProfile = 'users/me/';
}
