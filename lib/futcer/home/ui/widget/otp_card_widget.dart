import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:auth_app/futcer/home/ui/widget/build_card_title.dart';

import 'package:auth_app/core/theming/colors.dart';

class OtpCardWidget extends StatefulWidget {
  const OtpCardWidget({Key? key}) : super(key: key);

  @override
  State<OtpCardWidget> createState() => _OtpCardWidgetState();
}

class _OtpCardWidgetState extends State<OtpCardWidget> {
  static const String _defaultOtp = '000000';
  static const int _totalSeconds = 30;

  String _otpCode = _defaultOtp;
  int _remainingSeconds = 0;
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void generateOtp(String newOtp) {
    _startTimer();
    if (!mounted) return;
    setState(() {
      _otpCode = newOtp;
    });
  }

  void _startTimer() {
    _timer?.cancel();
    _remainingSeconds = _totalSeconds;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds <= 0) {
        timer.cancel();
        if (mounted) setState(() => _otpCode = _defaultOtp);
        return;
      }
      if (mounted) setState(() => _remainingSeconds--);
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
}
