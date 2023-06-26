

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:travel_planner_app_cs_project/main.dart';
import 'package:travel_planner_app_cs_project/models/registration.dart';
import 'package:travel_planner_app_cs_project/screens/authentication/login_screen.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:travel_planner_app_cs_project/widgets/bottom_navbar_widget.dart';

class EmailVerificationOTP extends ConsumerStatefulWidget {
  const EmailVerificationOTP(
      this._image,
      this.usernameController,
      this.emailController,
      this.passwordController,
      this.phoneController,
      this.datePicked,
      {super.key});

  final XFile? _image;
  final String usernameController;
  final String emailController;
  final String passwordController;
  final String phoneController;
  final String datePicked;

  @override
  _EmailVerificationOTPState createState() => _EmailVerificationOTPState();
}

class _EmailVerificationOTPState extends ConsumerState<EmailVerificationOTP> {
  bool _isEnabled = true;
  final _loginFormKey = GlobalKey<FormState>();

  final OtpFieldController otpController = OtpFieldController();

  final RoundedLoadingButtonController verifyOtpBtnController =
      RoundedLoadingButtonController();

  

  static SnackBar customSnackBar({required String content}) {
    return SnackBar(
      backgroundColor: Colors.black,
      content: Text(
        content,
        style: TextStyle(color: Colors.redAccent, letterSpacing: 0.5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String otpInput = ref.watch(otpControllerProvider).toString();

    void _doSomething(RoundedLoadingButtonController controller) async {
    try {
      if (_loginFormKey.currentState!.validate()) {
        registerUser(
          context,
          widget._image,
          widget.usernameController,
          widget.emailController,
          widget.phoneController,
          widget.passwordController,
          widget.datePicked,
          otpInput,
        );

        print(widget._image);
        print(widget.usernameController);
        print(widget.emailController);
        print(widget.phoneController);
        print(widget.passwordController);
        print(widget.datePicked);
        print(otpInput);

        final startTime = DateTime.now();
        final endTime = DateTime.now();
        final executionDuration = endTime.difference(startTime);
        if (executionDuration > Duration(seconds: 8)) {
          controller.error();
          controller.reset();
          return;
        }
        ref.read(accountCreationProvider.notifier).state = true;
      }
    } catch (e) {
      throw Exception(e);
    }
  }
  
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
                            length: 6,
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
                              ref.read(otpControllerProvider.notifier).state =
                                  pin.toString();
                            },
                            inputFormatter: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 38.0,
                        ),
                        RoundedLoadingButton(
                          height: 55.0,
                          color: Theme.of(context).primaryColor,
                          width: MediaQuery.of(context).size.width * 0.9,
                          successColor: Theme.of(context).primaryColor,
                          controller: verifyOtpBtnController,
                          onPressed: () => _doSomething(verifyOtpBtnController),
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
