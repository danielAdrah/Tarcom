import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/pages/sign_in.dart';
import '../../features/auth/presentation/pages/sign_up.dart';
import '../common/loading_page.dart';

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
  ],
);
