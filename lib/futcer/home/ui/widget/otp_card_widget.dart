import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auth_app/futcer/home/logic/cubit/otp_cubit.dart';
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

  void _resetToDefault() {
    _timer?.cancel();
    if (!mounted) return;
    setState(() {
      _otpCode = _defaultOtp;
      _remainingSeconds = 0;
    });
  }

  String get _formattedTime {
    final minutes = (_remainingSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (_remainingSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  // آمن ضد أي طول غير متوقع للـ OTP القادم من السيرفر
  String get _displayOtp {
    if (_otpCode.length == 6) {
      return '${_otpCode.substring(0, 3)} ${_otpCode.substring(3)}';
    }
    return _otpCode;
  }

  void _onOtpState(BuildContext context, OtpState state) {
    if (state is OtpFailure) {
      _resetToDefault();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.errMessage)));
    } else if (state is OtpExpiry) {
      _resetToDefault();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
    } else if (state is OtpSuccess) {
      final otp = state.otp;
      if (otp == null || otp.isEmpty) {
        _resetToDefault();
      } else {
        setState(() => _otpCode = otp);
        _startTimer();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OtpCubit, OtpState>(
      listener: _onOtpState,
      builder: (context, state) {
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
              if (state is OtpLoding)
                SizedBox(
                  height: 44.h,
                  child: const Center(child: CircularProgressIndicator()),
                )
              else
                _buildOtpCodeDisplay(),
              SizedBox(height: 16.h),
              _buildCountdownBadge(),
            ],
          ),
        );
      },
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
