import 'package:auth_app/core/theming/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BuildCardTitle extends StatelessWidget {
  const BuildCardTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
}
