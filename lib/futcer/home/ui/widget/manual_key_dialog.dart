import 'package:auth_app/core/theming/colors.dart';
import 'package:auth_app/futcer/home/logic/cubit/otp_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Future<void> showManualKeyDialog(BuildContext context) {
  final otpCubit = context.read<OtpCubit>();

  return showDialog<void>(
    context: context,
    barrierDismissible: true,
    builder: (dialogContext) => BlocProvider.value(value: otpCubit, child: const _ManualKeyDialogContent()),
  );
}

class _ManualKeyDialogContent extends StatefulWidget {
  const _ManualKeyDialogContent({Key? key}) : super(key: key);

  @override
  State<_ManualKeyDialogContent> createState() => _ManualKeyDialogContentState();
}

class _ManualKeyDialogContentState extends State<_ManualKeyDialogContent> {
  final TextEditingController _keyController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _keyController.dispose();
    super.dispose();
  }

  void _onSubmit(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      final String key = _keyController.text.trim();
      // بنطلب الكود، والـ BlocListener تحت هو اللي هيقفل الديالوج
      // لما يوصل رد فعلي من الـ Cubit (نجاح أو فشل)
      context.read<OtpCubit>().getOtp(key);
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.sizeOf(context).width;
    final double horizontalInset = screenWidth > 460 ? (screenWidth - 420) / 2 : 24;

    return BlocListener<OtpCubit, OtpState>(
      listener: (context, state) {
        // الديالوج بيقفل نفسه بس لو الطلب كان جاي من هنا فعلاً
        // (النجاح أو الفشل بيتصرفلهم كمان في OtpCardWidget)
        if (state is OtpSuccess || state is OtpFailure || state is OtpExpiry) {
          Navigator.of(context).pop();
        }
      },
      child: BlocBuilder<OtpCubit, OtpState>(
        builder: (context, state) {
          final bool isLoading = state is OtpLoding;

          return AlertDialog(
            backgroundColor: ColorsManager.myWhite,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
            insetPadding: EdgeInsets.symmetric(horizontal: horizontalInset, vertical: 24),
            title: Text(
              'إدخال المفتاح يدوياً',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold, color: ColorsManager.myBlack),
            ),
            content: SizedBox(
              width: 360.w,
              child: Form(
                key: _formKey,
                child: TextFormField(
                  controller: _keyController,
                  enabled: !isLoading,
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
                    if (value.trim().length < 32) {
                      return 'المفتاح يجب أن يكون على الأقل 32 حرفًا';
                    }
                    return null;
                  },
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: isLoading ? null : () => Navigator.pop(context),
                child: Text(
                  'إلغاء',
                  style: TextStyle(color: ColorsManager.myGrey, fontSize: 16.sp),
                ),
              ),
              ElevatedButton(
                onPressed: isLoading ? null : () => _onSubmit(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorsManager.myBlue,
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                ),
                child: isLoading
                    ? SizedBox(
                        width: 18.r,
                        height: 18.r,
                        child: const CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : Text(
                        'تأكيد',
                        style: TextStyle(color: Colors.white, fontSize: 16.sp),
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
