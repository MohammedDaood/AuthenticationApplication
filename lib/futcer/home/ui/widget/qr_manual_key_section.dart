import 'package:auth_app/futcer/home/logic/cubit/otp_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:auth_app/core/theming/colors.dart';
import 'package:auth_app/futcer/home/ui/widget/build_or_divider.dart';

class QrManualKeySection extends StatelessWidget {
  const QrManualKeySection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController _usernameController = TextEditingController();
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

    return Column(
      children: [
        _buildQrCircleButton(),
        SizedBox(height: 10.h),
        Text(
          'QR امسح رمز ال',
          style: TextStyle(color: ColorsManager.myGrey, fontSize: 18.sp, fontWeight: FontWeight.w500),
        ),
        SizedBox(height: 30.h),
        const BuildOrDivider(),
        SizedBox(height: 30.h),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: TextFormField(
                controller: _usernameController,
                textDirection: TextDirection.ltr,
                style: const TextStyle(
                  fontFamily: "formal",
                  fontWeight: FontWeight.normal,
                  fontSize: 16,
                  color: ColorsManager.myBlack,
                ),
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
            ),
            SizedBox(width: 10.w),
            BlocBuilder<OtpCubit, OtpState>(
              builder: (context, state) {
                return ElevatedButton(
                  onPressed: () async {
                    if (!_formKey.currentState!.validate()) return;
                    final code = _usernameController.text.trim();
                    final otp = await context.read<OtpCubit>().getOtp(code);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorsManager.myBlue,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                  ),
                  child: Text(
                    'إضافة',
                    style: TextStyle(color: Colors.white, fontSize: 16.sp, fontWeight: FontWeight.w500),
                  ),
                );
              },
            ),
          ],
        ),
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
}
