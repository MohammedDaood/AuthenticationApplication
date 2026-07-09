import 'package:auth_app/auth_app.dart';
import 'package:auth_app/core/di/dependency_injection.dart';
import 'package:auth_app/core/helper/shered_Pref.dart';
import 'package:auth_app/core/routing/app_router.dart';
import 'package:auth_app/core/routing/routes.dart';
import 'package:auth_app/core/theming/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupDependencyInjection();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: ColorsManager.myWhite,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
    ),
  );
  await PrefUtils.init();
  final isCompleted = PrefUtils.isOnboardingCompleted();
  final initialRoute = isCompleted ? Routes.homeScreen : Routes.onboardingScreen;

  runApp(AuthApp(appRouter: AppRouter(), initialRoute: initialRoute));
}
