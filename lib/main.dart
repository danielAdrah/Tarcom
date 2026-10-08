import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tarcom/core/di/injection_container.dart' as di;
import 'package:tarcom/features/auth/presentation/bloc/verify_otp/bloc/verify_otp_bloc.dart';
// import 'core/di/injection_container.dart';
import 'core/routes/route_main.dart';
import 'features/auth/presentation/bloc/sign_up.dart/bloc/sign_up_bloc.dart';
import 'generated/l10n.dart';
import 'core/constants/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await di.initDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
        ],
        child: MaterialApp.router(
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
