import 'dart:async';

import 'package:auth_app/core/helper/shered_Pref.dart';
import 'package:auth_app/core/theming/colors.dart';
import 'package:auth_app/futcer/home/logic/cubit/otp_cubit.dart';
import 'package:auth_app/futcer/home/ui/widget/build_card_title.dart';
import 'package:auth_app/futcer/home/ui/widget/build_or_divider.dart';
import 'package:auth_app/futcer/home/ui/widget/build_user_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const String _defaultOtp = '000000';
  static const int _totalSeconds = 30;

  String _otpCode = _defaultOtp;
  int _remainingSeconds = 0;
  Timer? _timer;

  final TextEditingController _usernameController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  DateTime? _lastBackPressTime;

  @override
  void initState() {
    super.initState();
    PrefUtils.setOnboardingCompleted();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _usernameController.dispose();
    super.dispose();
  }

  void generateOtp(String newOtp) {
    if (!mounted) return;
    setState(() {
      _otpCode = newOtp;
    });
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _remainingSeconds = _totalSeconds;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (_remainingSeconds <= 0) {
        timer.cancel();
        setState(() => _otpCode = _defaultOtp);
        return;
      }
      setState(() => _remainingSeconds--);
    });
  }

  String get _formattedTime {
    final minutes = (_remainingSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (_remainingSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  String get _displayOtp {
    if (_otpCode.length == 6) {
      return '${_otpCode.substring(0, 3)} ${_otpCode.substring(3)}';
    }
    return _otpCode;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        _onBackPressed(context);
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
                SizedBox(height: 50.h),
                _buildOtpCard(),
                SizedBox(height: 50.h),
                _buildQrManualKeySection(),
                SizedBox(height: 40.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onBackPressed(BuildContext context) {
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
          const BuildCardTitle(),
          SizedBox(height: 24.h),
          _buildOtpCodeDisplay(),
          SizedBox(height: 16.h),
          _buildCountdownBadge(),
        ],
      ),
    );
  }

  Widget _buildOtpCodeDisplay() {
    return Text(
      _displayOtp,
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 36.sp, letterSpacing: 8, color: ColorsManager.myBlack),
    );
  }

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

  // ---------------- QR + Manual key section ----------------

  Widget _buildQrManualKeySection() {
    return Column(
      children: [
        Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _usernameController,
                textDirection: TextDirection.ltr,
                style: const TextStyle(
                  fontFamily: "formal",
                  fontWeight: FontWeight.normal,
                  fontSize: 16,
                  color: ColorsManager.myBlack,
                ),
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  hintText: "ادخل الكود يدوياً",
                  hintStyle: const TextStyle(color: ColorsManager.myGrey),
                  prefixIcon: const Icon(Icons.numbers_rounded, color: ColorsManager.myBlue),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r), borderSide: BorderSide.none),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: const BorderSide(color: ColorsManager.myBlue, width: 1.5),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'الرجاء إدخال الكود';
                  }
                  if (value.trim().length < 32) {
                    return 'الكود يجب أن يكون 32 رقماً';
                  }
                  return null;
                },
              ),
              SizedBox(height: 12.h),
              BlocConsumer<OtpCubit, OtpState>(
                listener: (context, state) {
                  if (state is OtpFailure) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.errMessage)));
                  }
                  if (state is OtpSuccess) {
                    generateOtp(state.otp);
                    _usernameController.clear();
                  }
                },
                builder: (context, state) {
                  final isLoading = state is OtpLoding;
                  return ElevatedButton(
                    onPressed: isLoading
                        ? null
                        : () {
                            if (!_formKey.currentState!.validate()) return;
                            final code = _usernameController.text.trim();
                            context.read<OtpCubit>().getOtp(code);
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorsManager.myBlue,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                    ),
                    child: isLoading
                        ? SizedBox(
                            width: 18.r,
                            height: 18.r,
                            child: const CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                          )
                        : Text(
                            'تحقق من الكود',
                            style: TextStyle(color: Colors.white, fontSize: 16.sp, fontWeight: FontWeight.w500),
                          ),
                  );
                },
              ),
            ],
          ),
        ),
        SizedBox(height: 20.h),
        const BuildOrDivider(),
        SizedBox(height: 20.h),
        _buildQrCircleButton(),
        SizedBox(height: 10.h),
        Text(
          'QR امسح رمز ال',
          style: TextStyle(color: ColorsManager.myGrey, fontSize: 16.sp, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget _buildQrCircleButton() {
    return GestureDetector(
      onTap: () {
        // TODO: افتح شاشة QR Scanner
        // وبعد ما يترجع كود صح من الماسح، نادي:
        // final otp = await context.read<OtpCubit>().getOtp(scannedCode);
        // if (otp.isNotEmpty) generateOtp(otp);
      },
      child: Container(
        width: 90.r,
        height: 90.r,
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
        child: Icon(Icons.qr_code_scanner_rounded, color: Colors.white, size: 44.r),
      ),
    );
  }
}
