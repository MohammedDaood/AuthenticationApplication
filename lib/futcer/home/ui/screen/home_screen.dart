// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:auth_app/core/helper/shered_Pref.dart';
import 'package:auth_app/core/theming/colors.dart';

// ════════════════════════════════════════════════════════════
//  HOME SCREEN — StatefulWidget
// ════════════════════════════════════════════════════════════

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

// ════════════════════════════════════════════════════════════
//  STATE
// ════════════════════════════════════════════════════════════

class _HomeScreenState extends State<HomeScreen> {
  // ─── Constants ───────────────────────────────────────────
  static const String _otpCode = '000000';
  static const int _totalSeconds = 300; // 05:00

  // ─── State Variables ─────────────────────────────────────
  late int _remainingSeconds;
  Timer? _timer;

  // ─── Lifecycle ───────────────────────────────────────────

  @override
  void initState() {
    super.initState();
    // حفظ حالة الـ Onboarding عند دخول الشاشة
    PrefUtils.setOnboardingCompleted();
    _remainingSeconds = _totalSeconds;
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel(); // منع memory leak
    super.dispose();
  }

  // ─── Timer Logic ─────────────────────────────────────────

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds <= 0) {
        timer.cancel();
        return;
      }
      setState(() => _remainingSeconds--);
    });
  }

  // ─── Computed Properties ─────────────────────────────────

  /// يحوّل الثواني المتبقية إلى صيغة MM:SS
  String get _formattedTime {
    final minutes = (_remainingSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (_remainingSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  // ─── Actions ─────────────────────────────────────────────

  /// نسخ رمز OTP للحافظة مع إظهار إشعار
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

  // ════════════════════════════════════════════════════════
  //  BUILD
  // ════════════════════════════════════════════════════════

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsManager.myWhite,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 24.h),
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

  // ════════════════════════════════════════════════════════
  //  SECTION 1 — User Header
  // ════════════════════════════════════════════════════════

  /// أعلى الشاشة: اسم المستخدم + أفاتار دائري
  Widget _buildUserHeader() {
    return Row(
      children: [
        const Spacer(),

        // ── معلومات المستخدم (نص) ──
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              PrefUtils.getUsername(),
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold, color: ColorsManager.myBlack),
            ),

            SizedBox(height: 2.h),

            Text(
              'مرحباً بعودتك',
              style: TextStyle(fontSize: 10.sp, color: ColorsManager.myGrey),
            ),
          ],
        ),

        SizedBox(width: 12.w),

        // ── الأفاتار الدائري ──
        Container(
          width: 44.r,
          height: 44.r,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [ColorsManager.myBlue, ColorsManager.myBlue.withOpacity(0.7)],
            ),
            boxShadow: [
              BoxShadow(color: ColorsManager.myBlue.withOpacity(0.3), blurRadius: 12, offset: const Offset(0, 4)),
            ],
          ),
          child: const Icon(Icons.person_outline, color: Colors.white, size: 22),
        ),
      ],
    );
  }

  // ════════════════════════════════════════════════════════
  //  SECTION 2 — OTP Card
  // ════════════════════════════════════════════════════════

  /// البطاقة المركزية: رمز OTP + عداد تنازلي
  Widget _buildOtpCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28.r),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.white, ColorsManager.myBlue.withOpacity(0.06)],
        ),
        boxShadow: [
          BoxShadow(color: ColorsManager.myBlue.withOpacity(0.12), blurRadius: 24, offset: const Offset(0, 10)),
        ],
        border: Border.all(color: ColorsManager.myBlue.withOpacity(0.12)),
      ),
      child: Column(
        children: [
          // ── عنوان البطاقة ──
          _buildCardTitle(),

          SizedBox(height: 24.h),

          // ── الرمز القابل للنسخ ──
          _buildOtpCodeDisplay(),

          SizedBox(height: 16.h),

          // ── شارة العداد التنازلي ──
          _buildCountdownBadge(),
        ],
      ),
    );
  }

  /// عنوان بطاقة OTP
  Widget _buildCardTitle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.security_rounded, color: ColorsManager.myBlue, size: 18.r),

        SizedBox(width: 6.w),

        Text(
          'رمز التحقق المؤقت',
          style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, color: ColorsManager.myGrey),
        ),
      ],
    );
  }

  /// عرض الرمز السري — قابل للنسخ بالضغط
  Widget _buildOtpCodeDisplay() {
    return GestureDetector(
      onTap: _copyCode,
      child: Text(
        '${_otpCode.substring(0, 3)} ${_otpCode.substring(3)}',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 42.sp, fontWeight: FontWeight.bold, letterSpacing: 8, color: ColorsManager.myBlack),
      ),
    );
  }

  /// شارة العداد التنازلي
  Widget _buildCountdownBadge() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: ColorsManager.myBlue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.timer_outlined, color: ColorsManager.myBlue, size: 16.r),

          SizedBox(width: 6.w),

          Text(
            'متبقي $_formattedTime',
            style: TextStyle(color: ColorsManager.myBlue, fontWeight: FontWeight.bold, fontSize: 13.sp),
          ),
        ],
      ),
    );
  }

  // ════════════════════════════════════════════════════════
  //  SECTION 3 — QR Button + Manual Key
  // ════════════════════════════════════════════════════════

  /// أسفل الشاشة: زر QR Scanner + فاصل "أو" + زر المفتاح اليدوي
  Widget _buildQrButton() {
    return Column(
      children: [
        // ── زر QR الدائري ──
        _buildQrCircleButton(),

        SizedBox(height: 10.h),

        Text(
          'مسح رمز QR جديد',
          style: TextStyle(color: ColorsManager.myGrey, fontSize: 13.sp, fontWeight: FontWeight.w500),
        ),

        SizedBox(height: 20.h),

        // ── فاصل "أو" ──
        _buildOrDivider(),

        SizedBox(height: 20.h),

        // ── زر الإدخال اليدوي ──
        _buildManualKeyButton(),
      ],
    );
  }

  /// الزر الدائري لمسح QR
  Widget _buildQrCircleButton() {
    return GestureDetector(
      onTap: () {
        // TODO: افتح شاشة QR Scanner
      },
      child: Container(
        width: 76.r,
        height: 76.r,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [ColorsManager.myBlue, ColorsManager.myBlue.withOpacity(0.75)],
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
        child: Icon(Icons.qr_code_scanner_rounded, color: Colors.white, size: 34.r),
      ),
    );
  }

  /// فاصل "أو" بين الزرين
  Widget _buildOrDivider() {
    return Row(
      children: [
        const Expanded(child: Divider(thickness: 0.5)),

        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: Text(
            'أو',
            style: TextStyle(fontSize: 16.sp, color: ColorsManager.myGrey),
          ),
        ),

        const Expanded(child: Divider(thickness: 0.5)),
      ],
    );
  }

  /// زر الإدخال اليدوي للمفتاح
  Widget _buildManualKeyButton() {
    return GestureDetector(
      onTap: () => _showManualKeyDialog(context),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 16.h),
        decoration: BoxDecoration(
          color: ColorsManager.myWhite,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: ColorsManager.myBlue, width: 1.5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.keyboard_alt_outlined, color: ColorsManager.myBlue, size: 22.r),

            SizedBox(width: 8.w),

            Text(
              'إدخال المفتاح يدوياً',
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600, color: ColorsManager.myBlue),
            ),
          ],
        ),
      ),
    );
  }
}

void _showManualKeyDialog(BuildContext context) {
  final TextEditingController keyController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final double screenWidth = MediaQuery.sizeOf(context).width;

  // حساب الـ insetPadding لضبط عرض الـ Dialog على جميع أحجام الشاشات
  final double horizontalInset = screenWidth > 460 ? (screenWidth - 420) / 2 : 24;

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: ColorsManager.myWhite,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      insetPadding: EdgeInsets.symmetric(horizontal: horizontalInset, vertical: 24),

      // ── العنوان ──
      title: Text(
        'إدخال المفتاح يدوياً',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold, color: ColorsManager.myBlack),
      ),

      // ── حقل الإدخال ──
      content: SizedBox(
        width: 360.w,
        child: Form(
          key: formKey,
          child: TextFormField(
            controller: keyController,
            textAlign: TextAlign.center,
            textDirection: TextDirection.ltr,
            style: TextStyle(fontFamily: 'formal', fontSize: 17.sp, color: ColorsManager.myBlack),
            decoration: InputDecoration(
              hintText: 'أدخل المفتاح هنا',
              hintStyle: const TextStyle(color: ColorsManager.myGrey),
              filled: true,
              fillColor: Colors.grey.shade100,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.r), borderSide: BorderSide.none),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.r),
                borderSide: const BorderSide(color: ColorsManager.myBlue, width: 1.5),
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

      // ── الأزرار ──
      actions: [
        // زر الإلغاء
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            'إلغاء',
            style: TextStyle(color: ColorsManager.myGrey, fontSize: 16.sp),
          ),
        ),

        // زر التأكيد
        ElevatedButton(
          onPressed: () {
            if (formKey.currentState!.validate()) {
              final String key = keyController.text.trim();
              Navigator.pop(context);
              // TODO: استخدم الـ key لإضافة الحساب
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: ColorsManager.myBlue,
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
          ),
          child: Text(
            'تأكيد',
            style: TextStyle(color: Colors.white, fontSize: 16.sp),
          ),
        ),
      ],
    ),
  );
}
