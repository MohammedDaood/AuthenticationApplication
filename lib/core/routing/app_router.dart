import 'package:auth_app/core/api/dio_consumer.dart';
import 'package:auth_app/core/routing/routes.dart';
import 'package:auth_app/futcer/Onboarding/screens/onboarding_screen.dart';
import 'package:auth_app/futcer/home/logic/cubit/otp_cubit.dart';
import 'package:auth_app/futcer/home/ui/screen/home_screen.dart';
import 'package:auth_app/futcer/login/ui/screen/%20qr_scanner_screen.dart';
import 'package:auth_app/futcer/login/ui/screen/login_screen.dart';
import 'package:auth_app/futcer/login/ui/screen/username_password_Screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppRouter {
  Route generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.onboardingScreen:
        return MaterialPageRoute(builder: (_) => onboardingScreen());
      case Routes.loginScreen:
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case Routes.qrScannerScreen:
        return MaterialPageRoute(builder: (_) => QrScannerScreen());
      case Routes.homeScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider<OtpCubit>(
            create: (context) => OtpCubit(DioConsumer(dio: Dio())), // عدّل حسب طريقة الإنشاء عندك
            child: HomeScreen(),
          ),
        );
      case Routes.usernamePasswordScreen:
        return MaterialPageRoute(settings: settings, builder: (_) => const UsernamePasswordScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(body: Center(child: Text('No route defined for ${settings.name}'))),
        );
    }
  }
}
