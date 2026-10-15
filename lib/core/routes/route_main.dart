import 'route_imports.dart';
import '../../features/products/domain/entities/category_entity.dart';

final GoRouter router = GoRouter(
  initialLocation: '/',
  routes: <RouteBase>[
    GoRoute(path: '/', builder: (context, state) => const LoadingPage()),
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
    // GoRoute(
    //   path: '/verfiyCodePage',
    //   name: 'verfiyCodePage',
    //   builder: (context, state) => const VerfiyCodePage(),
    // ),
    GoRoute(
      path: '/verfiyCodePage',
      name: 'verfiyCodePage',
      builder: (context, state) {
        final String email = state.extra as String;
        return VerfiyCodePage(email: email);
      },
    ),
    GoRoute(
      path: '/homePage',
      name: 'homePage',
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: '/mainNavBar',
      name: 'mainNavBar',
      builder: (context, state) => const MainNavBar(),
    ),
    GoRoute(
      path: '/productsCategoryPage',
      name: 'productsCategoryPage',
      builder: (context, state) => const ProductsCategoryPage(),
    ),
    GoRoute(
      path: '/featuredProductsPage',
      name: 'featuredProductsPage',
      builder: (context, state) => const FeaturedProductsPage(),
    ),
    GoRoute(
      path: '/productsPage',
      name: 'productsPage',
      builder: (context, state) {
        final extra = state.extra;

        // التدفق الأساسي: كائن بيانات الصفحة (معرّفات الفئة والشركة) من صفحة الشركات.
        if (extra is ProductsPageArgs) {
          return ProductsPage(args: extra);
        }

        // دعم قديم: اسم الفئة فقط كنص بدون معرّفات.
        if (extra is String) {
          return ProductsPage(args: ProductsPageArgs(categoryName: extra));
        }

        return const ProductsPage(args: ProductsPageArgs());
      },
    ),

    GoRoute(
      path: '/productDetailsPage',
      name: 'productDetailsPage',
      builder: (context, state) {
        final extra = state.extra;

        // الحالة المعتادة: كائن بيانات المنتج الكامل من القوائم.
        if (extra is ProductDetailsArgs) {
          return ProductDetailsPage(
            proName: extra.name,
            proPrice: extra.price,
            proImage: extra.image,
            proDesc: extra.desc,
            proCategory: extra.category,
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

        // بدون بيانات: عرض صفحة فارغة بدلاً من الحدوث خطأ نوع.
        return const ProductDetailsPage(
          proName: '',
          proPrice: '',
          proImage: '',
          proDesc: '',
          proCategory: '',
        );
      },
    ),
    GoRoute(
      path: '/productsCompanyPage',
      name: 'productsCompanyPage',
      builder: (context, state) {
        final extra = state.extra;

        // التدفق الأساسي: كائن الفئة من صفحة الفئات، للفلترة بمعرّفها.
        if (extra is CategoryEntity) {
          return ProductsCompanyPage(category: extra);
        }

        // دعم الصفحة الرئيسية: اسم الفئة فقط بدون معرّف.
        if (extra is String) {
          return ProductsCompanyPage(categoryTitle: extra);
        }

        // بدون بيانات: عرض كل الشركات بدلاً من حدوث خطأ نوع.
        return const ProductsCompanyPage();
      },
    ),
    GoRoute(
      path: '/searchResultsPage',
      name: 'searchResultsPage',
      builder: (context, state) {
        final extra = state.extra;

        // التدفق الأساسي: نص البحث كنص من شريط البحث في الرئيسية.
        if (extra is String && extra.trim().isNotEmpty) {
          return SearchResultsPage(query: extra.trim());
        }

        // احتياط: نص فارغ يعرض صفحة نتائج برأس فارغ بدلاً من خطأ نوع.
        return SearchResultsPage(query: extra is String ? extra : '');
      },
    ),
  ],
);
