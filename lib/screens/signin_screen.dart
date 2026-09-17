import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:angcla_advmobprog_longexam1/constants.dart';
import 'package:angcla_advmobprog_longexam1/screens/home_screen.dart';
import 'package:angcla_advmobprog_longexam1/services/user_service.dart';
import 'package:angcla_advmobprog_longexam1/widgets/custom_dialogs.dart';
import 'package:angcla_advmobprog_longexam1/widgets/custom_font.dart';
import 'package:angcla_advmobprog_longexam1/widgets/custom_inkwell_button.dart';
import 'package:angcla_advmobprog_longexam1/widgets/custom_textformfield.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final UserService _userService = UserService();

  bool _isLoading = false;

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _signIn() async {
    // Validate username
    if (usernameController.text.trim().isEmpty) {
      customDialog(
        context,
        title: 'Invalid Input',
        content: 'Username cannot be empty',
      );
      return;
    }

    // Validate password
    if (passwordController.text.isEmpty) {
      customDialog(
        context,
        title: 'Invalid Input',
        content: 'Password cannot be empty',
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final user = await _userService.login(
        usernameController.text,
        passwordController.text,
      );
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen(user: user)),
      );
    } catch (e) {
      if (!mounted) return;
      final message = e.toString().replaceFirst('Exception: ', '');
      customDialog(context, title: 'Error', content: message);
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          height: ScreenUtil().screenHeight,
          width: ScreenUtil().screenWidth,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: ScreenUtil().screenWidth,
                  height: ScreenUtil().setHeight(40),
                  color: FB_DARK_PRIMARY,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: ScreenUtil().setWidth(25),
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: ScreenUtil().setHeight(180),
                        child: Center(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/images/intertwine_logo_cats.png',
                                  height: ScreenUtil().setHeight(120),
                                  fit: BoxFit.contain,
                                ),
                                SizedBox(height: ScreenUtil().setHeight(8)),
                                CustomFont(
                                  text: 'Intertwine',
                                  fontSize: ScreenUtil().setSp(30),
                                  color: FB_DARK_PRIMARY,
                                  fontFamily: 'Klavika',
                                  fontWeight: FontWeight.bold,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: ScreenUtil().setHeight(30)),
                      CustomTextFormField(
                        height: ScreenUtil().setHeight(10),
                        width: ScreenUtil().setWidth(10),
                        controller: usernameController,
                        validator: (value) => value!.isEmpty
                            ? 'Please enter your username'
                            : null,
                        onSaved: (value) => usernameController.text = value!,
                        fontSize: ScreenUtil().setSp(15),
                        fontColor: const Color(0xFF1E293B),
                        hintTextSize: ScreenUtil().setSp(15),
                        hintText: 'Username',
                      ),

                      SizedBox(height: ScreenUtil().setHeight(10)),

                      CustomTextFormField(
                        height: ScreenUtil().setHeight(10),
                        width: ScreenUtil().setWidth(10),
                        controller: passwordController,
                        isObscure: true,
                        validator: (value) => value!.isEmpty
                            ? 'Please enter your password'
                            : null,
                        onSaved: (value) => passwordController.text = value!,
                        fontSize: ScreenUtil().setSp(15),
                        fontColor: const Color(0xFF1E293B),
                        hintTextSize: ScreenUtil().setSp(15),
                        hintText: 'Password',
                      ),

                      SizedBox(height: ScreenUtil().setHeight(50)),

                      CustomInkwellButton(
                        onTap: _isLoading ? null : _signIn,
                        height: ScreenUtil().setHeight(40),
                        width: ScreenUtil().screenWidth,
                        buttonName: _isLoading ? 'Signing In...' : 'Login',
                        fontSize: ScreenUtil().setSp(15),
                        fontWeight: FontWeight.bold,
                        fontColor: const Color(0xFF0F2D1C),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: ScreenUtil().screenWidth,
                  height: ScreenUtil().setHeight(40),
                  color: FB_DARK_PRIMARY,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Don\'t have an account? ',
                        style: TextStyle(
                          color: const Color(0xFF0F2D1C),
                          fontSize: ScreenUtil().setSp(15),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      GestureDetector(
                        onTap: () =>
                            Navigator.popAndPushNamed(context, '/register'),
                        child: Text(
                          'Register here',
                          style: TextStyle(
                            color: const Color(0xFF880E4F),
                            fontSize: ScreenUtil().setSp(15),
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                        ),
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
