import 'package:auth_app/core/routing/app_router.dart';
import 'package:auth_app/core/theming/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AuthApp extends StatelessWidget {
  final AppRouter _appRouter = AppRouter();
  final String initialRoute;

  AuthApp({super.key, required AppRouter appRouter, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      child: MaterialApp(
        theme: ThemeData(
          fontFamily: 'cairo',
          primaryColor: ColorsManager.myBlue,
          scaffoldBackgroundColor: ColorsManager.myWhite,
        ),
        onGenerateRoute: _appRouter.generateRoute,
        initialRoute: initialRoute,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
