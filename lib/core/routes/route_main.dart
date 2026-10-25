import 'route_imports.dart';
import '../../features/products/domain/entities/category_entity.dart';

// ---------------------------------------------------------------------------
// بانٍ (builder) موحّد لكل صفحة عميقة. يُستعمل داخل أكثر من فرع، لذلك يبقى
// منطق استقبال [state.extra] كما هو ليتوافق مع مختلف مصادر الفتح.
// ---------------------------------------------------------------------------

Widget _buildCompanies(BuildContext context, GoRouterState state) {
  final extra = state.extra;

  // التدفق الأساسي: كائن الفئة من صفحة الفئات، للفلترة بمعرّفها.
  if (extra is CategoryEntity) {
    return ProductsCompanyPage(category: extra);
  }

  // دعم الصفحة الرئيسية: اسم الفئة فقط بدون معرّف.
  if (extra is String) {
    return ProductsCompanyPage(categoryTitle: extra);
  }

  // دعم اختصارات الوصول السريع: اسم داخلي للفئة لقيادة الجلب.
  if (extra is ProductsCompanyArgs) {
    return ProductsCompanyPage(
      categoryTitle: extra.categoryTitle,
      categoryInternalName: extra.categoryInternalName,
    );
  }

  // بدون بيانات: عرض كل الشركات بدلاً من حدوث خطأ نوع.
  return const ProductsCompanyPage();
}

Widget _buildProducts(BuildContext context, GoRouterState state) {
  final extra = state.extra;

  // التدفق الأساسي: كائن بيانات الصفحة (معرّفات الفئة والشركة).
  if (extra is ProductsPageArgs) {
    return ProductsPage(args: extra);
  }

  // دعم قديم: اسم الفئة فقط كنص بدون معرّفات.
  if (extra is String) {
    return ProductsPage(args: ProductsPageArgs(categoryName: extra));
  }

  return const ProductsPage(args: ProductsPageArgs());
}

Widget _buildDetails(BuildContext context, GoRouterState state) {
  final extra = state.extra;

  // الحالة المعتادة: كائن بيانات المنتج الكامل من القوائم.
  if (extra is ProductDetailsArgs) {
    return ProductDetailsPage(
      proName: extra.name,
      proPrice: extra.price,
      proImage: extra.image,
      proDesc: extra.desc,
      proCategory: extra.category,
      materialId: extra.materialId,
      proPriceInSp: extra.priceInSp,
      infoUrl: extra.infoUrl,
      infoFile: extra.infoFile,
      specifications: extra.specifications,
    );
  }

  // دعم قديم: قائمة مواصفات فقط.
  if (extra is List<MapEntry<String, String>>) {
    return ProductDetailsPage(
      proName: '',
      proPrice: '',
      proImage: '',
      proDesc: '',
      proCategory: '',
      specifications: extra,
    );
  }

  // بدون بيانات: عرض صفحة فارغة بدلاً من حدوث خطأ نوع.
  return const ProductDetailsPage(
    proName: '',
    proPrice: '',
    proImage: '',
    proDesc: '',
    proCategory: '',
  );
}

// المسارات العميقة المشتركة بين الفروع. دالةٌ لكل مسار لتوليد نسخة مستقلة
// من [GoRoute] داخل كل فرع (تفادياً مشاركة نفس الكائن بين أكثر من شجرة).
GoRoute _companiesRoute() =>
    GoRoute(path: NavPaths.companies, builder: _buildCompanies);

GoRoute _productsRoute() =>
    GoRoute(path: NavPaths.products, builder: _buildProducts);

GoRoute _detailsRoute() =>
    GoRoute(path: NavPaths.details, builder: _buildDetails);

final GoRouter router = GoRouter(
  initialLocation: '/',
  routes: <RouteBase>[
    GoRoute(path: '/', builder: (context, state) => const LoadingPage()),
    GoRoute(
      path: '/noInternetPage',
      name: 'noInternetPage',
      builder: (context, state) => const NoInternetPage(),
    ),
    GoRoute(
      path: '/signUpPage',
      name: 'signUpPage',
      builder: (context, state) => const SignUpPage(),
    ),
    GoRoute(
      path: '/signInPage',
      name: 'signInPage',
      builder: (context, state) => const SignInPage(),
    ),
    GoRoute(
      path: '/verfiyCodePage',
      name: 'verfiyCodePage',
      builder: (context, state) {
        final String email = state.extra as String;
        return VerfiyCodePage(email: email);
      },
    ),

    //shell: شريط تنقّل سفلي دائم فوق أربعة فروع، لكل فرع ملاحه الخاص
    // وحالته المحفوظة. الصفحات العميقة موصولة كأبناء داخل فرعها فيبقى
    // الشريط ظاهراً ويمكن التبديل فوراً بين التبويبات من أي شاشة.
    //
    // [FavoritesBloc] يُوفَّر على مستوى التطبيق في `main.dart` (نسخة واحدة
    // مشتركة)، ويُطلق `MainNavBar` طلب الجلب عند بناء الـ shell.
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          MainNavBar(navigationShell: navigationShell),
      branches: [
        // الفرع 0: الرئيسية
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/homePage',
              name: 'homePage',
              pageBuilder: (context, state) =>
                  const NoTransitionPage(child: HomePage()),
              routes: [
                _companiesRoute(),
                _productsRoute(),
                _detailsRoute(),
                GoRoute(
                  path: NavPaths.featured,
                  builder: (context, state) => const FeaturedProductsPage(),
                ),
                GoRoute(
                  path: NavPaths.search,
                  builder: (context, state) {
                    final extra = state.extra;
                    if (extra is String && extra.trim().isNotEmpty) {
                      return SearchResultsPage(query: extra.trim());
                    }
                    return SearchResultsPage(
                      query: extra is String ? extra : '',
                    );
                  },
                ),
                GoRoute(
                  path: NavPaths.userProfile,
                  builder: (context, state) => const UserProfilePage(),
                ),
              ],
            ),
          ],
        ),
        // الفرع 1: المنتجات (الفئات ← الشركات ← المنتجات ← التفاصيل)
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/productsCategoryPage',
              name: 'productsCategoryPage',
              pageBuilder: (context, state) =>
                  const NoTransitionPage(child: ProductsCategoryPage()),
              routes: [_companiesRoute(), _productsRoute(), _detailsRoute()],
            ),
          ],
        ),
        // الفرع 2: المفضلة
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/favoritesPage',
              name: 'favoritesPage',
              pageBuilder: (context, state) =>
                  const NoTransitionPage(child: FavoritesPage()),
              routes: [_detailsRoute()],
            ),
          ],
        ),
        // الفرع 3: تواصل معنا
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/contactusPage',
              name: 'contactusPage',
              pageBuilder: (context, state) =>
                  const NoTransitionPage(child: ContactusPage()),
            ),
          ],
        ),
      ],
    ),
  ],
);
