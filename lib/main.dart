import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tarcom/core/di/injection_container.dart' as di;
import 'package:tarcom/core/services/session_controller.dart';
import 'package:tarcom/features/auth/presentation/bloc/verify_otp/bloc/verify_otp_bloc.dart';
// import 'core/di/injection_container.dart';
import 'core/routes/route_main.dart';
import 'features/auth/presentation/bloc/sign_in.dart/bloc/sign_in_bloc.dart';
import 'features/auth/presentation/bloc/sign_up.dart/bloc/sign_up_bloc.dart';
import 'features/home/presentation/bloc/get_featured_materials/get_featured_materials_bloc.dart';
import 'features/products/presentation/bloc/bloc/get_categories_bloc.dart';
import 'generated/l10n.dart';
import 'core/constants/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await di.initDependencies();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // مفتاح عالمي لعرض رسالة انتهاء الجلسة فوق أي صفحة.
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  late final SessionController _sessionController;
  StreamSubscription<String>? _sessionSub;

  @override
  void initState() {
    super.initState();
    _sessionController = di.sl<SessionController>();
    // عند فشل تحديث الرمز ينهي SessionController الجلسة محلياً ويبثّ الحدث
    // هنا؛ فنوجّه المستخدم إجبارياً لصفحة الدخول مع رسالة توضيحية.
    _sessionSub = _sessionController.onExpired.listen((message) {
      router.goNamed('signInPage');
      final messenger = _scaffoldMessengerKey.currentState;
      messenger
        ?..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
        );
    });
  }

  @override
  void dispose() {
    _sessionSub?.cancel();
    super.dispose();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: false,
      builder: (_, child) => MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => di.sl<SignUpBloc>()),
          BlocProvider(create: (context) => di.sl<VerifyOtpBloc>()),
          BlocProvider(create: (context) => di.sl<SignInBloc>()),
          BlocProvider(create: (context) => di.sl<GetCategoriesBloc>()),
          BlocProvider(create: (context) => di.sl<GetFeaturedMaterialsBloc>()),
        ],
        child: MaterialApp.router(
          scaffoldMessengerKey: _scaffoldMessengerKey,
          routerConfig: router,
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          locale: const Locale('ar'),
          localizationsDelegates: [
            S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: S.delegate.supportedLocales,
        ),
      ),
    );
  }
}
