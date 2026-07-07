import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:auth_app/core/theming/colors.dart';
import 'package:auth_app/futcer/home/ui/widget/build_or_divider.dart';
import 'package:auth_app/futcer/home/ui/widget/manual_key_dialog.dart';

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
        const BuildOrDivider(),
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
