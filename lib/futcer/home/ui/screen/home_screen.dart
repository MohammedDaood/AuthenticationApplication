import 'package:auth_app/core/helper/shered_Pref.dart';
import 'package:auth_app/core/theming/colors.dart';
import 'package:auth_app/futcer/home/ui/widget/build_user_header.dart';
import 'package:auth_app/futcer/home/ui/widget/otp_card_widget.dart';
import 'package:auth_app/futcer/home/ui/widget/qr_manual_key_section.dart';
import 'package:flutter/material.dart';
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
    return Scaffold(
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
    );
  }
}
