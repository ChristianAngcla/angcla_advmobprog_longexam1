import 'package:angcla_advmobprog_longexam1/screens/signin_screen.dart';
import 'package:angcla_advmobprog_longexam1/widgets/custom_textformfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../constants.dart';
import '../widgets/custom_inkwell_button.dart';
import 'package:angcla_advmobprog_longexam1/widgets/custom_font.dart';
import '../widgets/custom_dialogs.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController mobilenumController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  Future<void> register() async {
    if (firstNameController.text.isEmpty ||
        lastNameController.text.isEmpty ||
        mobilenumController.text.isEmpty ||
        usernameController.text.isEmpty ||
        passwordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
      customDialog(
        context,
        title: 'Error',
        content: 'All fields are required to continue.',
      );
      return;
    }

    if (mobilenumController.text.length != 11) {
      customDialog(
        context,
        title: 'Error',
        content: 'The mobile number must be 11 digits.',
      );
      return;
    }

    final passwordRegex = RegExp(
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$',
    );

    if (!passwordRegex.hasMatch(passwordController.text)) {
      customDialog(
        context,
        title: 'Error',
        content:
            'Password should be 8 characters, a mixture of letters and numbers consisting of at least one special character with uppercase and lowercase letters.',
      );
      return;
    }

    if (passwordController.text != confirmPasswordController.text) {
      customDialog(context, title: 'Error', content: 'Passwords do not match.');
      return;
    }

    // Await truthful demo registration message
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Registration Demo'),
        content: const Text(
          'This registration form is preserved from the original app and does not create a DummyJSON account. Please sign in using an existing DummyJSON account.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Okay'),
          ),
        ],
      ),
    );

    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => const SignInScreen(),
      ),
      (route) => false, // removes all previous routes
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: ScreenUtil().screenHeight,
          width: ScreenUtil().screenWidth,
          padding: EdgeInsets.fromLTRB(
            ScreenUtil().setWidth(25),
            ScreenUtil().setHeight(40),
            ScreenUtil().setWidth(25),
            ScreenUtil().setHeight(10),
          ),
          child: Column(
            children: [
              SizedBox(height: ScreenUtil().setHeight(25)),
              CustomFont(
                text: 'Register Here',
                fontSize: ScreenUtil().setSp(50),
                fontWeight: FontWeight.bold,
                color: FB_DARK_PRIMARY,
              ),

              SizedBox(height: ScreenUtil().setHeight(25)),

              CustomTextFormField(
                height: ScreenUtil().setHeight(10),
                width: ScreenUtil().setWidth(10),
                onSaved: null,
                fontColor: null,
                validator: (value) => null,
                controller: firstNameController,
                fontSize: ScreenUtil().setSp(15),
                hintTextSize: ScreenUtil().setSp(15),
                hintText: 'First Name',
              ),
              SizedBox(height: ScreenUtil().setHeight(10)),

              CustomTextFormField(
                height: ScreenUtil().setHeight(10),
                width: ScreenUtil().setWidth(10),
                onSaved: null,
                fontColor: null,
                validator: (value) => null,
                controller: lastNameController,
                fontSize: ScreenUtil().setSp(15),
                hintTextSize: ScreenUtil().setSp(15),
                hintText: 'Last Name',
              ),

              SizedBox(height: ScreenUtil().setHeight(10)),

              CustomTextFormField(
                maxLength: 11,
                keyBoardType: TextInputType.number,
                height: ScreenUtil().setHeight(10),
                width: ScreenUtil().setWidth(10),
                onSaved: null,
                fontColor: null,
                hintText: 'Mobile Number',
                validator: (value) => null,
                hintTextSize: ScreenUtil().setSp(15),
                fontSize: ScreenUtil().setSp(15),
                controller: mobilenumController,
              ),
              SizedBox(height: ScreenUtil().setHeight(10)),

              CustomTextFormField(
                height: ScreenUtil().setHeight(10),
                width: ScreenUtil().setWidth(10),
                onSaved: null,
                fontColor: null,
                hintText: 'Username',
                validator: (value) => null,
                hintTextSize: ScreenUtil().setSp(15),
                fontSize: ScreenUtil().setSp(15),
                controller: usernameController,
              ),
              SizedBox(height: ScreenUtil().setHeight(10)),

              CustomTextFormField(
                isObscure: true,
                height: ScreenUtil().setHeight(10),
                width: ScreenUtil().setWidth(10),
                onSaved: null,
                fontColor: null,
                hintText: 'Password',
                validator: (value) => null,
                controller: passwordController,
                fontSize: ScreenUtil().setSp(15),
                hintTextSize: ScreenUtil().setSp(15),
              ),

              SizedBox(height: ScreenUtil().setHeight(10)),

              Text(
                '(Password should be 8 characters, a mixture of letter and numbers consisting of at least one speacial character with uppercase and lowercase letters.)',
                style: TextStyle(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.grey[400]
                      : const Color(0xFF334155),
                  fontSize: ScreenUtil().setSp(11),
                ),
              ),
              SizedBox(height: ScreenUtil().setHeight(10)),

              CustomTextFormField(
                isObscure: true,
                hintText: 'Confirm Password',
                height: ScreenUtil().setHeight(10),
                width: ScreenUtil().setWidth(10),
                onSaved: null,
                fontColor: null,
                validator: (value) => null,
                fontSize: ScreenUtil().setSp(15),
                hintTextSize: ScreenUtil().setSp(15),
                controller: confirmPasswordController,
              ),
              const Spacer(),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'You have an account? ',
                    style: TextStyle(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white70
                          : const Color(0xFF1E293B),
                      fontSize: ScreenUtil().setSp(15),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.popAndPushNamed(context, '/signin'),

                    child: Text(
                      'Login here',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: FB_DARK_PRIMARY,
                        fontSize: ScreenUtil().setSp(15),
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: ScreenUtil().setHeight(10)),

              CustomInkwellButton(
                onTap: () {
                  register();
                },
                height: ScreenUtil().setHeight(45),
                width: ScreenUtil().screenWidth,
                buttonName: 'Submit',
                fontSize: ScreenUtil().setSp(15),
                fontWeight: FontWeight.bold,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
