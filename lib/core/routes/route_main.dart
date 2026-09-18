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
  ],
);
