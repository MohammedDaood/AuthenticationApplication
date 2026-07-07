import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:auth_app/core/theming/colors.dart';

class BuildOrDivider extends StatelessWidget {
  const BuildOrDivider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
}
