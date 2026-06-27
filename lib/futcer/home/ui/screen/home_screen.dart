// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:auth_app/core/helper/shered_Pref.dart';
import 'package:auth_app/core/theming/colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const String _otpCode = '000000';
  static const int _totalSeconds = 300; // 05:00

  late int _remainingSeconds;
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    // وصول المستخدم لهذه الشاشة يعني إنه أكمل عملية الإقران/تسجيل الدخول بنجاح،
    // فنحفظ ذلك حتى لا تظهر له شاشة الـ onboarding أو تسجيل الدخول مرة أخرى عند فتح التطبيق
    PrefUtils.setOnboardingCompleted();

    _remainingSeconds = _totalSeconds;
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds <= 0) {
        timer.cancel();

        return;
      }
      setState(() => _remainingSeconds--);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String get _formattedTime {
    final minutes = (_remainingSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (_remainingSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  void _copyCode() {
    Clipboard.setData(const ClipboardData(text: _otpCode));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: ColorsManager.myBlue,
        duration: const Duration(seconds: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        content: const Row(
          children: [
            Icon(Icons.check_circle_outline, color: Colors.white, size: 20),
            SizedBox(width: 8),
            Text('تم نسخ الرمز', style: TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final bool isTablet = screenWidth >= 600;

    return Scaffold(
      backgroundColor: ColorsManager.myWhite,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isTablet ? 32.w : 24.w,
            vertical: 24.h,
          ),
          child: Column(
            children: [
              _buildUserHeader(),
              SizedBox(height: 36.h),
              const Spacer(flex: 1),
              _buildOtpCard(),
              const Spacer(flex: 2),
              _buildQrButton(),
              SizedBox(height: 40.h),
            ],
          ),
        ),
      ),
    );
  }

  /// معلومات المستخدم - في أعلى يمين الشاشة
  Widget _buildUserHeader() {
    return Row(
      children: [
        const Spacer(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              PrefUtils.getUsername(),
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
                color: ColorsManager.myBlack,
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              "مرحباً بعودتك",
              style: TextStyle(fontSize: 10.sp, color: ColorsManager.myGrey),
            ),
          ],
        ),
        SizedBox(width: 12.w),
        Container(
          width: 40.w,
          height: 40.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                ColorsManager.myBlue,
                ColorsManager.myBlue.withOpacity(0.7),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: ColorsManager.myBlue.withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Icon(Icons.person_outline, color: Colors.white),
        ),
      ],
    );
  }

  Widget _buildOtpCard() {
    final bool isExpiringSoon = _remainingSeconds <= 30;
    final double progress = _remainingSeconds / _totalSeconds;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 28.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28.r),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.white, ColorsManager.myBlue.withOpacity(0.06)],
        ),
        boxShadow: [
          BoxShadow(
            color: ColorsManager.myBlue.withOpacity(0.12),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
        border: Border.all(color: ColorsManager.myBlue.withOpacity(0.12)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.security_rounded,
                color: ColorsManager.myBlue,
                size: 18,
              ),
              SizedBox(width: 6.w),
              Text(
                "رمز التحقق المؤقت",
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: ColorsManager.myGrey,
                ),
              ),
            ],
          ),
          SizedBox(height: 22.h),

          /// الرمز كنص واحد في المنتصف
          GestureDetector(
            onTap: _copyCode,
            child: Text(
              '${_otpCode.substring(0, 3)} ${_otpCode.substring(3)}',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 42.sp,
                fontWeight: FontWeight.bold,
                letterSpacing: 8,
                color: ColorsManager.myBlack,
              ),
            ),
          ),

          SizedBox(height: 10.h),

          Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: ColorsManager.myBlue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.timer_outlined,
                  color: ColorsManager.myBlue,
                  size: 16,
                ),
                SizedBox(width: 6.w),
                Text(
                  "متبقي $_formattedTime",
                  style: TextStyle(
                    color: ColorsManager.myBlue,
                    fontWeight: FontWeight.bold,
                    fontSize: 13.sp,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQrButton() {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            // افتح شاشة QR Scanner
          },
          child: Container(
            width: 76.w,
            height: 76.w,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  ColorsManager.myBlue,
                  ColorsManager.myBlue.withOpacity(0.75),
                ],
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: ColorsManager.myBlue.withOpacity(0.35),
                  blurRadius: 20,
                  spreadRadius: 2,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: const Icon(
              Icons.qr_code_scanner_rounded,
              color: Colors.white,
              size: 34,
            ),
          ),
        ),
        SizedBox(height: 12.h),
        Text(
          "مسح رمز QR جديد",
          style: TextStyle(
            color: ColorsManager.myGrey,
            fontSize: 13.sp,
            fontWeight: FontWeight.w500,
          ),
        ),

        Row(
          children: [
            const Expanded(child: Divider(thickness: 0.5)),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: Text(
                "أو",
                style: TextStyle(fontSize: 20, color: ColorsManager.myGrey),
              ),
            ),
            const Expanded(child: Divider(thickness: 0.5)),
          ],
        ),

        GestureDetector(
          onTap: () => _showManualKeyDialog(context),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: ColorsManager.myWhite,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: ColorsManager.myBlue, width: 1.5),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.keyboard_alt_outlined,
                  color: ColorsManager.myBlue,
                  size: 24,
                ),
                SizedBox(width: 8.w),
                Text(
                  "إدخال المفتاح يدوياً",
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: ColorsManager.myBlue,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

void _showManualKeyDialog(BuildContext context) {
  final TextEditingController keyController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final screenWidth = MediaQuery.sizeOf(context).width;
  final bool isTablet = screenWidth >= 600;

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: ColorsManager.myWhite,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      // Keeps the dialog from stretching across a tablet screen.
      insetPadding: EdgeInsets.symmetric(
        horizontal: isTablet ? (screenWidth - 420) / 2 : 24,
        vertical: 24,
      ),
      title: Text(
        "إدخال المفتاح يدوياً",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: isTablet ? 20.sp : 18.sp,
          fontWeight: FontWeight.bold,
          color: ColorsManager.myBlack,
        ),
      ),
      content: SizedBox(
        width: isTablet ? 360.w : double.maxFinite,
        child: Form(
          key: formKey,
          child: TextFormField(
            controller: keyController,
            textAlign: TextAlign.center,
            textDirection: TextDirection.ltr,
            style: TextStyle(
              fontFamily: "formal",
              fontWeight: FontWeight.normal,
              fontSize: isTablet ? 17.sp : 16.sp,
              color: ColorsManager.myBlack,
            ),
            decoration: InputDecoration(
              hintText: "أدخل المفتاح هنا",
              hintStyle: const TextStyle(color: ColorsManager.myGrey),
              filled: true,
              fillColor: Colors.grey.shade100,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.r),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.r),
                borderSide: const BorderSide(
                  color: ColorsManager.myBlue,
                  width: 1.5,
                ),
              ),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'الرجاء إدخال المفتاح';
              }
              return null;
            },
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            "إلغاء",
            style: TextStyle(
              color: ColorsManager.myGrey,
              fontSize: isTablet ? 16.sp : 14.sp,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            if (formKey.currentState!.validate()) {
              final key = keyController.text.trim();
              Navigator.pop(context);
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: ColorsManager.myBlue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
          ),
          child: Text(
            "تأكيد",
            style: TextStyle(
              color: Colors.white,
              fontSize: isTablet ? 16.sp : 14.sp,
            ),
          ),
        ),
      ],
    ),
  );
}
