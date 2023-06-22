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
    File imageFile = File(image!.path);
    List<int> imageBytes = imageFile.readAsBytesSync();
    String base64Image = base64Encode(imageBytes);
    final response = await http.post(
      Uri.parse("https://fari-jcuo.onrender.com/main/register"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'image': base64Image,
        'name': username,
        'email': email,
        'password': password,
        'phone': phone,
        'dob': dob,
        'code': code,
      }),
    );
    if (response.statusCode == 200) {
      setAccountCreationBool();
      return Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
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
