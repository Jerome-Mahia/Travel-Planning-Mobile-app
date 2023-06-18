import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:travel_planner_app_cs_project/main.dart';
import 'package:travel_planner_app_cs_project/screens/authentication/login_screen.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:travel_planner_app_cs_project/widgets/bottom_navbar_widget.dart';

class EmailVerificationOTP extends ConsumerStatefulWidget {
  const EmailVerificationOTP({super.key});

  @override
  _EmailVerificationOTPState createState() => _EmailVerificationOTPState();
}

class _EmailVerificationOTPState extends ConsumerState<EmailVerificationOTP> {
  bool _isEnabled = true;
  final _loginFormKey = GlobalKey<FormState>();
  OtpFieldController otpController = OtpFieldController();
  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();
  final RoundedLoadingButtonController makePlanBtnController =
      RoundedLoadingButtonController();

  setAccountCreationBool() async {
    SharedPreferences mode = await SharedPreferences.getInstance();
    bool isAccountPresent = await mode.setBool('isAccountPresent', true);
    return isAccountPresent;
  }

  void _doSomething() async {
    Timer(const Duration(seconds: 2), () {
      // makePlanBtnController.success();
      setAccountCreationBool();
      ref.read(accountCreationProvider.notifier).state = true;
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
          ),
          surfaceTintColor: Colors.white,
          elevation: 0.0,
        ),
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20.0, left: 20, right: 20),
              child: ListView(
                children: [
                  SvgPicture.asset(
                    'assets/images/reset_svg.svg',
                    height: MediaQuery.of(context).size.height * 0.36,
                  ),
                  Form(
                    key: _loginFormKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Email OTP',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 35,
                          ),
                        ),
                        SizedBox(
                          height: 9,
                        ),
                        Text(
                          'Kindly enter the email verification otp sent to your email address',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[700],
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Center(
                          child: OTPTextField(
                              controller: otpController,
                              length: 5,
                              width: MediaQuery.of(context).size.width,
                              textFieldAlignment: MainAxisAlignment.spaceAround,
                              fieldWidth: 45,
                              fieldStyle: FieldStyle.box,
                              outlineBorderRadius: 15,
                              style: TextStyle(fontSize: 17),
                              onChanged: (pin) {
                                print("Changed: " + pin);
                              },
                              onCompleted: (pin) {
                                print("Completed: " + pin);
                              }),
                        ),
                        const SizedBox(
                          height: 38.0,
                        ),
                        RoundedLoadingButton(
                          height: 55.0,
                          color: Theme.of(context).primaryColor,
                          width: MediaQuery.of(context).size.width * 0.9,
                          successColor: Theme.of(context).primaryColor,
                          resetDuration: const Duration(seconds: 3),
                          controller: makePlanBtnController,
                          onPressed: () => _doSomething(),
                          resetAfterDuration: true,
                          valueColor: Colors.white,
                          borderRadius: 15,
                          child: const Text(
                            'Verify',
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Didn\'t receive?',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w200,
                                ),
                              ),
                              TextButton(
                                onPressed: () {},
                                child: Text(
                                  'Resend Code',
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
