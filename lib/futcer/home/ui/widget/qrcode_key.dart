import 'package:auth_app/futcer/home/logic/cubit/otp_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:auth_app/core/theming/colors.dart';

class QrManualKeySection extends StatelessWidget {
  const QrManualKeySection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildQrCircleButton(),

        SizedBox(height: 10.h),

        Text(
          'QR امسح رمز ال',
          style: TextStyle(color: ColorsManager.myGrey, fontSize: 18.sp, fontWeight: FontWeight.w500),
        ),

        SizedBox(height: 30.h),

        _buildOrDivider(),

        SizedBox(height: 30.h),

        _buildManualKeyButton(context),
      ],
    );
  }

  Widget _buildQrCircleButton() {
    return GestureDetector(
      onTap: () {
        // TODO: افتح شاشة QR Scanner
      },
      child: Container(
        width: 100.r,
        height: 100.r,
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

  Widget _buildOrDivider() {
    return Row(
      children: [
        const Expanded(child: Divider(thickness: 0.5)),

        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: Text(
            'أو',
            style: TextStyle(fontSize: 18.sp, color: ColorsManager.myGrey),
          ),
        ),

        const Expanded(child: Divider(thickness: 0.5)),
      ],
    );
  }

  Widget _buildManualKeyButton(BuildContext context) {
    return GestureDetector(
      onTap: () => showManualKeyDialog(context),
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

Future<String?> showManualKeyDialog(BuildContext context) {
  final TextEditingController keyController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final double screenWidth = MediaQuery.sizeOf(context).width;
  final double horizontalInset = screenWidth > 460 ? (screenWidth - 420) / 2 : 24;

  final otpCubit = context.read<OtpCubit>(); // يمسكها من الـ route provider الجديد

  return showDialog<String?>(
    context: context,
    builder: (dialogContext) => BlocProvider.value(
      value: otpCubit,
      child: AlertDialog(
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
            onPressed: () => Navigator.pop(dialogContext, null),
            child: Text(
              'إلغاء',
              style: TextStyle(color: ColorsManager.myGrey, fontSize: 16.sp),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                final String key = keyController.text.trim();
                dialogContext.read<OtpCubit>().getOtp(key);
                Navigator.pop(dialogContext, key);
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
    ),
  );
}
