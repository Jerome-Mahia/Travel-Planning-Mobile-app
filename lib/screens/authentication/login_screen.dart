import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:travel_planner_app_cs_project/main.dart';
import 'package:travel_planner_app_cs_project/screens/authentication/registration_screen.dart';
import 'package:travel_planner_app_cs_project/screens/authentication/reset_password_screen.dart';
import 'package:travel_planner_app_cs_project/widgets/bottom_navbar_widget.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:travel_planner_app_cs_project/screens/authentication/sign_in_options.dart';
import 'package:local_auth/local_auth.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  bool _isEnabled = true;
  final _loginFormKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();
  final RoundedLoadingButtonController makePlanBtnController =
      RoundedLoadingButtonController();

  void _doSomething(RoundedLoadingButtonController controller) async {
    Timer(const Duration(seconds: 2), () {
      // makePlanBtnController.success();
      if (_loginFormKey.currentState!.validate()) {
        controller.success();
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const BottomNavBar()),
        ); // ref.read(authProvider.notifier).state = true;
      } else {
        controller.error();
      }
    });
  }

  bool passToggle = true;

  late final LocalAuthentication _localAuthentication;
  bool _supportState = false;

  @override
  void initState() {
    super.initState();
    _localAuthentication = LocalAuthentication();
    _localAuthentication.isDeviceSupported().then((bool isSupported) {
      setState(() {
        _supportState = isSupported;
      });
    });
  }

  Future<void> _authenticate() async {
    try {
      bool authenticated = await _localAuthentication.authenticate(
        localizedReason: 'Scan your fingerprint to authenticate',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
      if (authenticated) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const BottomNavBar()),
        );
      }
    } on PlatformException catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    Future<bool> isAccountCreated() async {
      SharedPreferences mode = await SharedPreferences.getInstance();
      bool isAccountPresent = mode.getBool('isAccountPresent') ?? false;
      print('isAccountPresent: $isAccountPresent');
      return isAccountPresent;
    }

    bool isCreated = ref.watch(accountCreationProvider);

    return FutureBuilder<bool>(
      future: isAccountCreated(),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        snapshot.data == true || isCreated == true
            ? Future.delayed(Duration.zero, () => _authenticate())
            : Container();
        return SafeArea(
          child: Scaffold(
            appBar: AppBar(
              leading: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SignInOptionScreen(),
                    ),
                  );
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
                  padding:
                      const EdgeInsets.only(top: 20.0, left: 20, right: 20),
                  child: ListView(
                    children: [
                      SvgPicture.asset(
                        'assets/images/login_svg.svg',
                        height: MediaQuery.of(context).size.height * 0.36,
                      ),
                      Form(
                        key: _loginFormKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Login',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 35,
                              ),
                            ),
                            SizedBox(
                              height: 9,
                            ),
                            TextFormField(
                              controller: emailController,
                              enabled: _isEnabled,
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                if (value == null || !value.contains('@')) {
                                  return 'Please provide a valid email address';
                                } else {
                                  return null;
                                }
                              },
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
                                hintText: 'Email',
                                prefixIcon: const Icon(
                                  Icons.email_rounded,
                                  size: 20.0,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20.0,
                            ),
                            TextFormField(
                              controller: passwordController,
                              enabled: _isEnabled,
                              validator: (value) {
                                if (value == null || value.length < 8) {
                                  return 'Please provide a password with more than 8 characters';
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
                              onPressed: () =>
                                  _doSomething(makePlanBtnController),
                              resetAfterDuration: true,
                              valueColor: Colors.white,
                              borderRadius: 15,
                              child: const Text(
                                'Login',
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
                              'Forgot your Password?',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w200,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => ResetPasswordScreen(),
                                  ),
                                );
                              },
                              child: Text(
                                'Reset Password',
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
                      Center(
                        child: Text('Or'),
                      ),
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'New to HouseHunter?',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w200,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => RegistrationScreen(),
                                  ),
                                );
                              },
                              child: Text(
                                'Register',
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
      },
    );
  }
}
