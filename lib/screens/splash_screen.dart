import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:angcla_advmobprog_longexam1/constants.dart';
import 'package:angcla_advmobprog_longexam1/models/user.dart';
import 'package:angcla_advmobprog_longexam1/screens/home_screen.dart';
import 'package:angcla_advmobprog_longexam1/screens/signin_screen.dart';
import 'package:angcla_advmobprog_longexam1/services/user_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final UserService _userService = UserService();
  int _currentFrame = 1;
  Timer? _animationTimer;

  @override
  void initState() {
    super.initState();
    _startAnimation();
    _initializeApp();
  }

  void _startAnimation() {
    _animationTimer = Timer.periodic(const Duration(milliseconds: 250), (timer) {
      if (mounted) {
        setState(() {
          _currentFrame = _currentFrame < 4 ? _currentFrame + 1 : 1;
        });
      }
    });
  }

  @override
  void dispose() {
    _animationTimer?.cancel();
    super.dispose();
  }

  Future<void> _initializeApp() async {
    final splashDelay = Future.delayed(const Duration(seconds: 4));

    User? user;
    try {
      user = await _userService.getSavedUser();
    } catch (_) {
      user = null;
    }

    // Ensure the intended splash duration completes before navigating
    await splashDelay;

    if (!mounted) return;

    final bool hasSession =
        user != null &&
        user.accessToken != null &&
        user.accessToken!.isNotEmpty;

    if (hasSession) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen(user: user!)),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SignInScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(
          horizontal: ScreenUtil().setWidth(30),
          vertical: ScreenUtil().setHeight(20),
        ),
        height: ScreenUtil().screenHeight,
        width: ScreenUtil().screenWidth,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Authentic Intertwine Cat Logo
            Image.asset(
              'assets/images/intertwine_logo_cats.png',
              height: ScreenUtil().setHeight(220),
              fit: BoxFit.contain,
            ),
            SizedBox(height: ScreenUtil().setHeight(16)),
            // Helen Hayes Quote with crisp contrast
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: ScreenUtil().setWidth(20),
              ),
              child: Text(
                '"The expert in anything was once a beginner."\n— Helen Hayes',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: ScreenUtil().setSp(13),
                  color: isDark ? Colors.grey.shade300 : const Color(0xFF2C3E50),
                  fontWeight: FontWeight.w600,
                  fontStyle: FontStyle.italic,
                  height: 1.4,
                ),
              ),
            ),
            SizedBox(height: ScreenUtil().setHeight(50)),
            // 4-Frame Progressive Loading Bar
            Container(
              width: ScreenUtil().setWidth(200),
              height: ScreenUtil().setHeight(12),
              decoration: BoxDecoration(
                color: isDark ? Colors.grey.shade800 : Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: FB_DARK_PRIMARY, width: 1.5),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: _currentFrame / 4.0,
                child: Container(
                  decoration: BoxDecoration(
                    color: FB_LIGHT_PRIMARY,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            SizedBox(height: ScreenUtil().setHeight(15)),
            // High-contrast Loading Text
            Text(
              'Loading . . .',
              style: TextStyle(
                fontSize: ScreenUtil().setSp(16),
                fontWeight: FontWeight.bold,
                color: FB_DARK_PRIMARY,
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
