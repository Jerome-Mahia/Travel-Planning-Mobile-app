import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:travel_planner_app_cs_project/main.dart';
import 'package:travel_planner_app_cs_project/models/edit_user_details.dart';
import 'package:travel_planner_app_cs_project/models/login.dart';
import 'package:travel_planner_app_cs_project/screens/settings/view_profile_screen.dart';
import 'package:http/http.dart' as http;

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  bool _isEnabled = true;
  final _editProfileFormKey = GlobalKey<FormState>();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  final RoundedLoadingButtonController editProfileBtnController =
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
  Widget build(BuildContext context) {
    editUserDetails(BuildContext context, String name, String phone,
        DateTime dob, String image, int id) async {
      try {
        final Accesstoken = await retrieveToken();
        final response = await http.post(
          Uri.parse("https://fari-jcuo.onrender.com/main/user-details"),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer ${Accesstoken.toString()}',
          },
          body: jsonEncode(<String, String>{
            'name': name,
            'phone': phone,
            'dob': dob.toString(),
            'image': image,
            'id': id.toString(),
          }),
        );
        if (response.statusCode == 200) {
          final body = json.decode(response.body);
          ref.read(usernameProvider.notifier).state = body['name'];
          ref.read(useremailProvider.notifier).state = body['email'];
          ref.read(userphoneProvider.notifier).state = body['phone'];
          ref.read(userimageProvider.notifier).state = body['image'];
          ref.read(useridProvider.notifier).state = body['id'];
          return Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ViewProfileScreen()),
          );
        } else {
          return SnackBar(content: Text('Unable to edit user details'));
        }
      } catch (e) {
        print(e.toString());
        throw Exception('Failed to edit user details: $e');
      }
    }

    void _doSomething(RoundedLoadingButtonController controller) async {
      try {
        String dob= ref.watch(userdobProvider).toString();
        if (_editProfileFormKey.currentState!.validate()) {
          // editUserDetails(context, usernameController.text,
          //     phoneController.text, dob, _image!.path, 1);
          final startTime = DateTime.now();
          final endTime = DateTime.now();
          final executionDuration = endTime.difference(startTime);
          if (executionDuration > Duration(seconds: 10)) {
            controller.error();
            controller.reset();
            return;
          }
        } else {
          controller.error();
        }
      } catch (e) {
        throw Exception(e);
      }
    }

    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.black,
        centerTitle: true,
        title: const Text('Edit Profile'),
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20.0, left: 20, right: 20),
              child: Column(
                children: [
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
                    height: 20,
                  ),
                  Form(
                    key: _editProfileFormKey,
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
                          height: 40.0,
                        ),
                        RoundedLoadingButton(
                          height: 55.0,
                          color: Theme.of(context).primaryColor,
                          width: MediaQuery.of(context).size.width * 0.9,
                          successColor: Theme.of(context).primaryColor,
                          controller: editProfileBtnController,
                          onPressed: () =>
                              _doSomething(editProfileBtnController),
                          resetAfterDuration: true,
                          valueColor: Colors.white,
                          borderRadius: 15,
                          child: const Text(
                            'Save Changes',
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
