// lib/screens/splash_screen.dart
import 'dart:async';
import 'package:auth_app/core/helper/extensions.dart';
import 'package:auth_app/core/routing/routes.dart';
import 'package:auth_app/core/theming/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class onboardingScreen extends StatefulWidget {
  const onboardingScreen({super.key});

  @override
  State<onboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<onboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // متغير جديد: بنخزن فيه آخر وقت ضغط فيه المستخدم زر الرجوع
  DateTime? _lastBackPressTime;

  final List<OnboardingModel> _onboardingPages = [
    OnboardingModel(
      title: 'أمان أقوى معنا',
      description: 'احصل على حماية متقدمة لبياناتك الشخصية',
      image: SvgPicture.asset('assets/svgs/firstimage.svg', width: 300, height: 300),
    ),
    OnboardingModel(
      title: ' أعداد سهل وبسيط باستخدام كاميرتك',
      description: ' سوف تقوم بمسح كود لتسجيل الدخول بسرعة باستخدام كاميرتك',
      image: SvgPicture.asset('assets/svgs/Secondimage.svg', width: 300, height: 300),
    ),
    OnboardingModel(
      title: 'رمز فريد يستخدم لتسجيل الدخول',
      description: 'عند استدخدامك للتحقق بخطوتين سوف تقوم بادخال كلمة مرورك ورمز من هذا التطبيق',
      image: SvgPicture.asset('assets/svgs/Thirdimage.svg', width: 300, height: 300),
    ),
  ];

  void _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  Future<void> _onGetStarted() async {
    if (!mounted) return;
    context.pushAndRemoveUntil(Routes.loginScreen, predicate: (route) => false);
  }

  void _onBackPressed() {
    final now = DateTime.now();

    if (_lastBackPressTime == null || now.difference(_lastBackPressTime!) > const Duration(seconds: 2)) {
      _lastBackPressTime = now;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('اضغط رجوع مرة أخرى للخروج'), duration: Duration(seconds: 2)));
    } else {
      SystemNavigator.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;

        _onBackPressed();
      },
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [ColorsManager.myWhite, Color(0xFFF5F5F5)],
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: _onPageChanged,
                    itemCount: _onboardingPages.length,
                    itemBuilder: (context, index) {
                      return OnboardingPageContent(model: _onboardingPages[index]);
                    },
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(30),
                  child: Column(
                    children: [
                      SmoothPageIndicator(
                        controller: _pageController,
                        count: _onboardingPages.length,
                        effect: const WormEffect(
                          dotHeight: 10,
                          dotWidth: 10,
                          activeDotColor: ColorsManager.myBlue,
                          dotColor: ColorsManager.myGrey,
                        ),
                      ),
                      const SizedBox(height: 30),

                      if (_currentPage == _onboardingPages.length - 1)
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: _onGetStarted,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ColorsManager.myBlue,
                              foregroundColor: ColorsManager.myWhite,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                            ),
                            child: const Text('ابدأ الآن', style: TextStyle(fontSize: 18)),
                          ),
                        )
                      else
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const SizedBox(width: 60),
                            ElevatedButton(
                              onPressed: () {
                                _pageController.nextPage(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: ColorsManager.myBlue,
                                foregroundColor: ColorsManager.myWhite,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                              ),
                              child: const Text('التالي'),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class OnboardingModel {
  final String title;
  final String description;
  final Widget image;

  OnboardingModel({required this.title, required this.description, required this.image});
}

class OnboardingPageContent extends StatelessWidget {
  final OnboardingModel model;

  const OnboardingPageContent({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(padding: const EdgeInsets.all(30), child: model.image),
        const SizedBox(height: 40),
        Text(
          model.title,
          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Text(
            model.description,
            style: const TextStyle(fontSize: 16, color: ColorsManager.myGrey),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
