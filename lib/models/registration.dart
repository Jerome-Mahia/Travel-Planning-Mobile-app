// To parse this JSON data, do
//
//     final registration = registrationFromJson(jsonString);

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:travel_planner_app_cs_project/main.dart';
import 'package:travel_planner_app_cs_project/screens/authentication/login_screen.dart';
import 'package:travel_planner_app_cs_project/screens/home/feed_screen.dart';
import 'package:travel_planner_app_cs_project/widgets/bottom_navbar_widget.dart';

Registration registrationFromJson(String str) =>
    Registration.fromJson(json.decode(str));

String registrationToJson(Registration data) => json.encode(data.toJson());

class Registration {
  String refresh;
  String access;

  Registration({
    required this.refresh,
    required this.access,
  });

  factory Registration.fromJson(Map<String, dynamic> json) => Registration(
        refresh: json["refresh"],
        access: json["access"],
      );

  Map<String, dynamic> toJson() => {
        "refresh": refresh,
        "access": access,
      };
}

setAccountCreationBool() async {
  SharedPreferences mode = await SharedPreferences.getInstance();
  bool isAccountPresent = await mode.setBool('isAccountPresent', true);
  return isAccountPresent;
}

registerUser(BuildContext context, XFile? image, String username, String email,
    String phone, String password, String dob, String code) async {
  try {
    File? imageFile = image != null ? File(image!.path) : null;
List<int>? imageBytes = imageFile != null ? imageFile.readAsBytesSync() : null;

final request = http.MultipartRequest(
  'POST',
  Uri.parse("https://fari-jcuo.onrender.com/main/register"),
);

if (imageBytes != null) {
  request.files.add(
    http.MultipartFile.fromBytes(
      'image',
      imageBytes,
      filename: 'image.jpg',
    ),
  );
}

request.fields['name'] = username;
request.fields['email'] = email;
request.fields['password'] = password;
request.fields['phone'] = phone;
request.fields['dob'] = dob;
request.fields['code'] = code;

final response = await request.send();
if (response.statusCode == 200) {
  setAccountCreationBool();
  return Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const BottomNavBar()),
        (Route<dynamic> route) => false,
      );
} else {
  print(response.statusCode.toString());
  throw Exception('Failed to register user');
}
  } catch (e) {
    print(e.toString());
    throw Exception('Failed to register user: $e');
  }
}
