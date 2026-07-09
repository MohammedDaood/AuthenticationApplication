import 'package:auth_app/core/helper/extensions.dart';
import 'package:auth_app/core/routing/routes.dart';
import 'package:auth_app/core/theming/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    DateTime? _lastBackPressTime;

    void _onBackPressed() {
      final now = DateTime.now();

      if (_lastBackPressTime == null || now.difference(_lastBackPressTime!) > const Duration(seconds: 2)) {
        _lastBackPressTime = now;

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('اضغط رجوع مرة أخرى للخروج'), duration: Duration(seconds: 2)));
      } else {
        SystemNavigator.pop();
      }
    }

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        _onBackPressed();
      },
      child: Scaffold(
        backgroundColor: ColorsManager.myWhite,
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            'assets/svgs/login.svg',
                            width: 0.55.sw, // نسبة من عرض الشاشة بدل رقم ثابت
                            height: 0.55.sw,
                          ),
                          SizedBox(height: 40.h),

                          Text(
                            "تسجيل الدخول",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 26.sp,
                              fontWeight: FontWeight.bold,
                              color: ColorsManager.myBlack,
                            ),
                          ),
                          SizedBox(height: 8.h),

                          Text(
                            "قم بمسح رمز الكود لتسجيل الدخول",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 14.sp, color: ColorsManager.myGrey),
                          ),
                          SizedBox(height: 50.h),

                          GestureDetector(
                            onTap: () async {
                              await context.pushNamed(Routes.qrScannerScreen);
                            },
                            child: Container(
                              width: 70.w,
                              height: 70.w,
                              decoration: BoxDecoration(
                                color: ColorsManager.myBlue,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: ColorsManager.myBlue.withOpacity(0.4),
                                    blurRadius: 20.r,
                                    spreadRadius: 4.r,
                                    offset: Offset(0, 6.h),
                                  ),
                                ],
                              ),
                              child: Icon(Icons.qr_code_scanner_rounded, size: 36.sp, color: ColorsManager.myWhite),
                            ),
                          ),

                          SizedBox(height: 12.h),
                          Text(
                            "اضغط لمسح الكود",
                            style: TextStyle(fontSize: 12.sp, color: ColorsManager.myGrey),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
