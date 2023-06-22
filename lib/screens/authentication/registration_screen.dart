import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:travel_planner_app_cs_project/main.dart';
import 'package:travel_planner_app_cs_project/models/sendcode.dart';
import 'package:travel_planner_app_cs_project/screens/authentication/email_verification_otp.dart';
import 'package:travel_planner_app_cs_project/screens/authentication/login_screen.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class RegistrationScreen extends ConsumerStatefulWidget {
  const RegistrationScreen({super.key});

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends ConsumerState<RegistrationScreen> {
  bool _isEnabled = true;
  final _registrationFormKey = GlobalKey<FormState>();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController datePickedInput = TextEditingController();

  final RoundedLoadingButtonController verifyOtpBtnController =
      RoundedLoadingButtonController();
  XFile? _image;
  bool passToggle = true;

  selectCameraImage() async {
    Navigator.of(context).pop();
    XFile? im = await ImagePicker().pickImage(source: ImageSource.camera);
    setState(() {
      _image = im;
    });
  }

  selectGalleryImage() async {
    Navigator.of(context).pop();
    XFile? im = await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      _image = im;
    });
  }

  _selectImage(BuildContext parentContext) async {
    return showDialog(
      context: parentContext,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Center(child: const Text('Upload Image')),
          children: <Widget>[
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text('Take a photo'),
              onPressed: selectCameraImage,
            ),
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text('Choose from Gallery'),
              onPressed: selectGalleryImage,
            ),
            Center(
              child: SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child:
                    const Text("Cancel", style: TextStyle(color: Colors.red)),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            )
          ],
        );
      },
    );
  }

  @override
  void initState() {
    datePickedInput.text = "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String datePicked = ref.watch(datePickedProvider).toString();

    void _doSomething(RoundedLoadingButtonController controller) async {
      try {
        if (_registrationFormKey.currentState!.validate()) {
          sendEmailVerification(emailController.text);
          final startTime = DateTime.now();
          final endTime = DateTime.now();
          final executionDuration = endTime.difference(startTime);
          if (executionDuration > Duration(seconds: 10)) {
            controller.error();
            controller.reset();
            return;
          }

          print(_image);
          print(usernameController.text);
          print(emailController.text);
          print(passwordController.text);
          print(phoneController.text);
          print(datePicked);

          controller.success();
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => EmailVerificationOTP(
                    _image,
                    usernameController.text,
                    emailController.text,
                    passwordController.text,
                    phoneController.text,
                    datePicked)),
          ); // ref.read(authProvider.notifier).state = true;
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
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
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
              padding: const EdgeInsets.only(top: 20.0, left: 20, right: 20),
              child: ListView(
                children: [
                  Text(
                    'Sign Up',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 35,
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  GestureDetector(
                    onTap: () => _selectImage(context),
                    child: Center(
                      child: Stack(
                        children: [
                          _image != null
                              ? CircleAvatar(
                                  radius: 64,
                                  backgroundImage: MemoryImage(
                                    File(_image!.path).readAsBytesSync(),
                                  ),
                                  backgroundColor: Colors.grey,
                                )
                              : const CircleAvatar(
                                  radius: 64,
                                  backgroundImage: AssetImage(
                                    "assets/images/profile_avatar.png",
                                  ),
                                  backgroundColor: Colors.grey,
                                ),
                          Positioned(
                            bottom: -10,
                            left: 80,
                            child: IconButton(
                              onPressed: () => _selectImage(context),
                              icon: const Icon(Icons.add_a_photo),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Form(
                    key: _registrationFormKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          controller: usernameController,
                          enabled: _isEnabled,
                          keyboardType: TextInputType.text,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a username';
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
                            hintText: 'Username',
                            prefixIcon: const Icon(
                              Icons.account_box_rounded,
                              size: 20.0,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20.0,
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
                          keyboardType: TextInputType.text,
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
                          height: 20,
                        ),
                        IntlPhoneField(
                          controller: phoneController,
                          initialCountryCode: 'KE',
                          invalidNumberMessage:
                              'Please provide a valid number starting with \'07..\'',
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
                            hintText: 'Phone Number',
                          ),
                          onChanged: (phone) {
                            print(phone.completeNumber);
                          },
                          onCountryChanged: (country) {
                            print('Country changed to: ' + country.name);
                          },
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
                              'Provide a phone number starting with \'07..\'',
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
                          keyboardType: TextInputType.datetime,
                          controller: datePickedInput,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please provide a valid date of birth';
                            } else {
                              DateTime currentDate = DateTime.now();
                              DateTime enteredDate =
                                  DateFormat.yMMMMd().parse(value);
                              String jsonDate =
                                  DateFormat('yyyy-MM-dd').format(enteredDate);

                              ref.read(datePickedProvider.notifier).state =
                                  jsonDate;

                              Duration difference =
                                  currentDate.difference(enteredDate);
                              int age = (difference.inDays / 365).floor();

                              if (age >= 18) {
                                return null; // Valid age
                              } else {
                                return 'You must be at least 18 years old';
                              }
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
                            hintText: 'Date of Birth',
                            prefixIcon: const Icon(
                              Icons.calendar_today,
                              size: 20.0,
                            ),
                          ),
                          readOnly:
                              true, // Set it to true, so that the user cannot edit the text
                          onTap: () async {
                            DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(1930),
                              lastDate: DateTime(2100),
                            );
                            if (pickedDate != null) {
                              String formattedPickedDate =
                                  DateFormat.yMMMMd().format(pickedDate);
                              setState(() {
                                datePickedInput.text =
                                    formattedPickedDate; // Set output date range to TextField value
                              });
                            }
                          },
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
                            'Sign Up',
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
                    height: 20,
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