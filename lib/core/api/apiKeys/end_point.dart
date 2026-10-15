class EndPoint {
  EndPoint._();

  static const String baseUrl = 'https://rabee371.pythonanywhere.com/api/';

  static const String signUp = 'auth/signup/';
  static const String signIn = 'auth/login/';
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
}
