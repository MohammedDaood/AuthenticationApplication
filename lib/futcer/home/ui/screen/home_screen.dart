import 'package:auth_app/core/helper/shered_Pref.dart';
import 'package:auth_app/core/theming/colors.dart';
import 'package:auth_app/futcer/home/ui/widget/build_user_header.dart';
import 'package:auth_app/futcer/home/ui/widget/otp_card_widget.dart';
import 'package:auth_app/futcer/home/ui/widget/qr_manual_key_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    PrefUtils.setOnboardingCompleted();
  }

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
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 24.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const BuildUserHeader(),
                SizedBox(height: 60.h),
                const OtpCardWidget(),
                SizedBox(height: 60.h),
                const QrManualKeySection(),
                SizedBox(height: 40.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
