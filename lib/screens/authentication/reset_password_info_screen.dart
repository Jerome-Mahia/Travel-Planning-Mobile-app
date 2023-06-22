import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:travel_planner_app_cs_project/screens/authentication/login_screen.dart';
import 'package:travel_planner_app_cs_project/screens/authentication/registration_screen.dart';
import 'package:travel_planner_app_cs_project/screens/authentication/reset_password_screen.dart';
import 'package:travel_planner_app_cs_project/widgets/bottom_navbar_widget.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:travel_planner_app_cs_project/screens/authentication/sign_in_options.dart';

class ResetPasswordFormScreen extends StatefulWidget {
  const ResetPasswordFormScreen({super.key});

  @override
  State<ResetPasswordFormScreen> createState() =>
      _ResetPasswordFormScreenState();
}

class _ResetPasswordFormScreenState extends State<ResetPasswordFormScreen> {
  bool _isEnabled = true;
  bool passToggle = true;
  final _resetPasswordFormKey = GlobalKey<FormState>();

  final TextEditingController passwordController = TextEditingController();

  final TextEditingController confirmPasswordController =
      TextEditingController();
  final RoundedLoadingButtonController makePlanBtnController =
      RoundedLoadingButtonController();

  void _doSomething(RoundedLoadingButtonController controller) async {
    Timer(const Duration(seconds: 2), () {
      if (_resetPasswordFormKey.currentState!.validate()) {
        String newPassword = passwordController.text;
        String confirmedPassword = confirmPasswordController.text;

        if (newPassword == confirmedPassword) {
          // Passwords match, proceed with success action
          controller.success();
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const LoginScreen()),
          );
        } else {
          // Passwords do not match, show error message
          controller.error();
        }
      } else {
        // Form validation failed, show error message
        controller.error();
      }
    });
  }

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
                    'assets/images/sign_up_svg.svg',
                    height: MediaQuery.of(context).size.height * 0.36,
                  ),
                  Form(
                    key: _resetPasswordFormKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Reset Password',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 35,
                          ),
                        ),
                        SizedBox(
                          height: 9,
                        ),
                        TextFormField(
                          controller: passwordController,
                          enabled: _isEnabled,
                          validator: (value) {
                            if (value == null || value.length < 8) {
                              return 'Please provide a password more than 8 characters';
                            } else {
                              return null;
                            }
                          },
                          obscureText: passToggle,
                          enableSuggestions: false,
                          autocorrect: false,
                          decoration: InputDecoration(
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 15.0),
                            border: UnderlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: const BorderSide(
                                width: 0.5,
                              ),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: const BorderSide(
                                width: 0.5,
                                color: Colors.grey,
                              ),
                            ),
                            hintText: 'Password',
                            prefixIcon: const Icon(
                              Icons.lock,
                              size: 20.0,
                            ),
                            suffixIcon: InkWell(
                              onTap: () {
                                setState(() {
                                  passToggle = !passToggle;
                                });
                              },
                              child: Icon(
                                passToggle
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        TextFormField(
                          controller: confirmPasswordController,
                          enabled: _isEnabled,
                          validator: (value) {
                            if (value == null || value.length < 8) {
                              return 'Please provide a password more than 8 characters';
                            } else {
                              return null;
                            }
                          },
                          obscureText: passToggle,
                          enableSuggestions: false,
                          autocorrect: false,
                          decoration: InputDecoration(
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 15.0),
                            border: UnderlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: const BorderSide(
                                width: 0.5,
                              ),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: const BorderSide(
                                width: 0.5,
                                color: Colors.grey,
                              ),
                            ),
                            hintText: 'Confirm Password',
                            prefixIcon: const Icon(
                              Icons.lock,
                              size: 20.0,
                            ),
                            suffixIcon: InkWell(
                              onTap: () {
                                setState(() {
                                  passToggle = !passToggle;
                                });
                              },
                              child: Icon(
                                passToggle
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 38.0,
                        ),
                        RoundedLoadingButton(
                          height: 55.0,
                          color: Theme.of(context).primaryColor,
                          width: MediaQuery.of(context).size.width * 0.9,
                          successColor: Colors.green,
                          errorColor: Colors.red,
                          resetDuration: const Duration(seconds: 4),
                          controller: makePlanBtnController,
                          onPressed: () => _doSomething(makePlanBtnController),
                          resetAfterDuration: true,
                          valueColor: Colors.white,
                          borderRadius: 15,
                          child: const Text(
                            'Reset Password',
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
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
                          'Already have an account?',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w200,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => LoginScreen(),
                              ),
                            );
                          },
                          child: Text(
                            'Login',
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
                  SizedBox(
                    height: 10.0,
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
