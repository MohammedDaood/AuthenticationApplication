import 'package:auth_app/core/helper/shered_Pref.dart';
import 'package:auth_app/core/theming/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BuildUserHeader extends StatelessWidget {
  const BuildUserHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String username = PrefUtils.getUsername() == null || PrefUtils.getUsername() == ''
        ? 'username'
        : PrefUtils.getUsername();

    return Row(
      children: [
        const Spacer(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              username,
              style: TextStyle(fontSize: 14.sp, color: ColorsManager.myBlack),
            ),
            SizedBox(height: 2.h),
            Text(
              'مرحباً بعودتك',
              style: TextStyle(fontSize: 10.sp, color: ColorsManager.myBlack),
            ),
          ],
        ),
        SizedBox(width: 12.w),
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
          child: const Icon(Icons.person_outline, color: Colors.white, size: 26),
        ),
      ],
    );
  }
}
