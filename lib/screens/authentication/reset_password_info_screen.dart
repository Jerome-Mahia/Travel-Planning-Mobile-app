import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:travel_planner_app_cs_project/main.dart';
import 'package:travel_planner_app_cs_project/models/reset_password.dart';
import 'package:travel_planner_app_cs_project/screens/authentication/login_screen.dart';
import 'package:travel_planner_app_cs_project/screens/authentication/registration_screen.dart';
import 'package:travel_planner_app_cs_project/screens/authentication/reset_password_screen.dart';
import 'package:travel_planner_app_cs_project/widgets/bottom_navbar_widget.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:travel_planner_app_cs_project/screens/authentication/sign_in_options.dart';

class ResetPasswordFormScreen extends ConsumerStatefulWidget {
  const ResetPasswordFormScreen({super.key});
  @override
  _ResetPasswordFormScreenState createState() =>
      _ResetPasswordFormScreenState();
}

class _ResetPasswordFormScreenState
    extends ConsumerState<ResetPasswordFormScreen> {
  bool _isEnabled = true;
  bool passToggle = true;
  final _resetPasswordFormKey = GlobalKey<FormState>();

  final TextEditingController passwordController = TextEditingController();

  final TextEditingController confirmPasswordController =
      TextEditingController();
  final RoundedLoadingButtonController resetPasswordBtnController =
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
    _doSomething(RoundedLoadingButtonController controller) async {
      if (_resetPasswordFormKey.currentState!.validate()) {
        String newPassword = passwordController.text;
        String confirmedPassword = confirmPasswordController.text;
        String email = ref.watch(emailProvider).toString();
        String otpInput = ref.watch(otpControllerProvider).toString();
        print(email);
        print(otpInput);
        print(confirmedPassword);

        if (newPassword == confirmedPassword) {
          // Passwords match, proceed with success action
          resetPassword(
            context,
            email,
            confirmedPassword,
            otpInput,
          );
        } else {
          // Passwords do not match, show error message
          SnackBar snackBar = SnackBar(
            backgroundColor: Colors.black,
            content: Text(
              'Passwords do not match',
              style: TextStyle(color: Colors.redAccent, letterSpacing: 0.5),
            ),
          );
          controller.error();
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      } else {
        // Form validation failed, show error message
        controller.error();
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
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.info_outline_rounded,
                              size: 20.0,
                              color: const Color.fromARGB(255, 0, 104, 190),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              'Password must be at least 8 characters',
                              style: TextStyle(
                                fontSize: 12.0,
                                color: const Color.fromARGB(255, 0, 104, 190),
                              ),
                            ),
                          ],
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
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.info_outline_rounded,
                              size: 20.0,
                              color: const Color.fromARGB(255, 0, 104, 190),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              'Passwords must match with each other',
                              style: TextStyle(
                                fontSize: 12.0,
                                color: const Color.fromARGB(255, 0, 104, 190),
                              ),
                            ),
                          ],
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
                          controller: resetPasswordBtnController,
                          onPressed: () =>
                              _doSomething(resetPasswordBtnController),
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
