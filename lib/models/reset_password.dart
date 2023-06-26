// To parse this JSON data, do
//
//     final resetPassword = resetPasswordFromJson(jsonString);

import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:travel_planner_app_cs_project/screens/authentication/login_screen.dart';

ResetPassword resetPasswordFromJson(String str) =>
    ResetPassword.fromJson(json.decode(str));

String resetPasswordToJson(ResetPassword data) => json.encode(data.toJson());

class ResetPassword {
  String email;
  String code;
  String password;

  ResetPassword({
    required this.email,
    required this.code,
    required this.password,
  });

  factory ResetPassword.fromJson(Map<String, dynamic> json) => ResetPassword(
        email: json["email"],
        code: json["code"],
        password: json["password"],
      );

  Map<String, dynamic> toJson() => {
        "email": email,
        "code": code,
        "password": password,
      };
}

resetPassword(
    BuildContext context, String email, String password, String code) async {
  try {
    final response = await http.post(
      Uri.parse("https://fari-jcuo.onrender.com/main/reset-password"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'email': email,
        'password': password,
        'code': code,
      }),
    );
    if (response.statusCode == 201) {
      return Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    } else {
      throw Exception(response.reasonPhrase);
    }
  } catch (e) {
    print(e.toString());
    throw Exception('Failed to reset password: $e');
  }
}
