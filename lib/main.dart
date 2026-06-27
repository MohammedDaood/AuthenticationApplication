import 'package:auth_app/auth_app.dart';
import 'package:auth_app/core/helper/shered_Pref.dart';
import 'package:auth_app/core/routing/app_router.dart';
import 'package:auth_app/core/routing/routes.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PrefUtils.init();
  final isCompleted = PrefUtils.isOnboardingCompleted();
  final initialRoute = isCompleted
      ? Routes.homeScreen
      : Routes.onboardingScreen;

  runApp(AuthApp(appRouter: AppRouter(), initialRoute: initialRoute));
}
