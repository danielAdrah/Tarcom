import 'route_imports.dart';

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
      path: '/productsPage',
      name: 'productsPage',
      builder: (context, state) {
        final String proCategory = state.extra as String;
        return ProductsPage(productsCatTitle: proCategory);
      },
    ),
    GoRoute(
      path: '/productDetailsPage',
      name: 'productDetailsPage',
      builder: (context, state) {
        final specifications = state.extra;
        if (specifications is List<MapEntry<String, String>>) {
          return ProductDetailsPage(specifications: specifications);
        }
        return const ProductDetailsPage();
      },
    ),
    GoRoute(
      path: '/productsCompanyPage',
      name: 'productsCompanyPage',
      builder: (context, state) {
        final String catagoryTitle = state.extra as String;
        return ProductsCompanyPage(catagoryTitle: catagoryTitle);
      },
      // => const ProductsCompanyPage(),
    ),
  ],
);
