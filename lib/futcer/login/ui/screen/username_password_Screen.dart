import 'package:auth_app/core/api/dio_consumer.dart';
import 'package:auth_app/core/helper/device_id.dart';
import 'package:auth_app/core/helper/extensions.dart';
import 'package:auth_app/core/helper/shered_Pref.dart';
import 'package:auth_app/core/routing/routes.dart';
import 'package:auth_app/core/theming/colors.dart';
import 'package:auth_app/futcer/login/logic/cubit/login_cubit.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class UsernamePasswordScreen extends StatefulWidget {
  const UsernamePasswordScreen({super.key});

  @override
  State<UsernamePasswordScreen> createState() => _UsernamePasswordScreenState();
}

class _UsernamePasswordScreenState extends State<UsernamePasswordScreen> {
  final TextEditingController _usernameController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _obscurePassword = true;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit(String qrCode) {
    if (!_formKey.currentState!.validate()) return;
  }

  @override
  Widget build(BuildContext context) {
    final qrCode = ModalRoute.of(context)?.settings.arguments as String?;

    return BlocProvider(
      create: (context) => LoginCubit(DioConsumer(dio: Dio())),
      child: Scaffold(
        backgroundColor: ColorsManager.myWhite,
        body: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 30.h),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset('assets/svgs/login.svg', width: 400.w, height: 300.h),

                    Text(
                      "أهلاً بك",
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: ColorsManager.myBlack),
                    ),

                    SizedBox(height: 5.h),

                    Text(
                      "أدخل بيانات الدخول للمتابعة",
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16, color: ColorsManager.myGrey),
                    ),

                    SizedBox(height: 32.h),

                    TextFormField(
                      controller: _usernameController,
                      textDirection: TextDirection.ltr,
                      style: const TextStyle(
                        fontFamily: "formal",
                        fontWeight: FontWeight.normal,
                        fontSize: 16,
                        color: ColorsManager.myBlack,
                      ),
                      decoration: InputDecoration(
                        hintText: "اسم المستخدم",
                        hintStyle: const TextStyle(color: ColorsManager.myGrey),
                        prefixIcon: const Icon(Icons.person_outline, color: ColorsManager.myBlue),
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: const BorderSide(color: ColorsManager.myBlue, width: 1.5),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'الرجاء إدخال اسم المستخدم';
                        }
                        return null;
                      },
                    ),

                    SizedBox(height: 16.h),

                    TextFormField(
                      controller: _passwordController,
                      textDirection: TextDirection.ltr,
                      obscureText: _obscurePassword,
                      style: const TextStyle(
                        fontFamily: "formal",
                        fontWeight: FontWeight.normal,
                        fontSize: 16,
                        color: ColorsManager.myBlack,
                      ),
                      decoration: InputDecoration(
                        hintText: "كلمة المرور",
                        hintStyle: const TextStyle(color: ColorsManager.myGrey),
                        prefixIcon: const Icon(Icons.lock_outline, color: ColorsManager.myBlue),
                        suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                          child: Icon(
                            _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                            color: ColorsManager.myGrey,
                          ),
                        ),
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: const BorderSide(color: ColorsManager.myBlue, width: 1.5),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'الرجاء إدخال كلمة المرور';
                        }
                        if (value.length < 8) {
                          return 'كلمة المرور يجب أن تكون 8 أحرف على الأقل';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 32.h),
                    BlocConsumer<LoginCubit, LoginState>(
                      listener: (context, state) {
                        if (state is LoginSuccess) {
                          PrefUtils.saveUsername(_usernameController.text);
                          context.pushAndRemoveUntil(
                            Routes.homeScreen,
                            arguments: _usernameController.text,
                            predicate: (route) => false,
                          );
                        } else if (state is LoginFailure) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.errMessage)));
                        }
                      },
                      builder: (context, state) {
                        return state is LoginLoding
                            ? CircularProgressIndicator()
                            : GestureDetector(
                                onTap: () async {
                                  // this fun for validate
                                  if (!_formKey.currentState!.validate()) return;

                                  final android_id = await getDeviceId() ?? '';
                                  PrefUtils.saveDeviceId(android_id);
                                  print("Device ID: $android_id");

                                  // we get the id
                                  // we need to send data to cubit
                                  context.read<LoginCubit>().Login(
                                    _usernameController.text,
                                    _passwordController.text,
                                    qrCode.toString(),
                                    android_id,
                                  );
                                },

                                child: Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.symmetric(vertical: 15.h),
                                  decoration: BoxDecoration(
                                    color: ColorsManager.myBlue,
                                    borderRadius: BorderRadius.circular(12.r),
                                    boxShadow: [
                                      BoxShadow(
                                        color: ColorsManager.myBlue.withOpacity(0.4),
                                        blurRadius: 20,
                                        spreadRadius: 2,
                                        offset: const Offset(0, 6),
                                      ),
                                    ],
                                  ),
                                  child: const Text(
                                    "تسجيل الدخول",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: ColorsManager.myWhite,
                                    ),
                                  ),
                                ),
                              );
                      },
                    ),
                    SizedBox(height: 70.h),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
