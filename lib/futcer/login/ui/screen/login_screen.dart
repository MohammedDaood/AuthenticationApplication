import 'package:auth_app/core/helper/extensions.dart';
import 'package:auth_app/core/routing/routes.dart';
import 'package:auth_app/core/theming/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsManager.myWhite,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/svgs/login.svg',
                    width: 400,
                    height: 400,
                  ),
                  SizedBox(height: 50),

                  Text(
                    "تسجيل الدخول",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: ColorsManager.myBlack,
                    ),
                  ),
                  SizedBox(height: 5.h),

                  Text(
                    "قم بمسح رمز الكود لتسجيل الدخول",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, color: ColorsManager.myGrey),
                  ),
                  SizedBox(height: 70),

                  GestureDetector(
                    onTap: () async {
                      final result = await context.pushNamed(
                        Routes.qrScannerScreen,
                      );
                      if (result != null) {}
                    },
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: ColorsManager.myBlue,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: ColorsManager.myBlue.withOpacity(0.4),
                            blurRadius: 20,
                            spreadRadius: 4,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.qr_code_scanner_rounded,
                        size: 44,
                        color: ColorsManager.myWhite,
                      ),
                    ),
                  ),

                  SizedBox(height: 16),
                  Text(
                    "اضغط لمسح الكود",
                    style: TextStyle(fontSize: 14, color: ColorsManager.myGrey),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
