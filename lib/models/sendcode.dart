// To parse this JSON data, do
//
//     final sendCode = sendCodeFromJson(jsonString);

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:travel_planner_app_cs_project/screens/authentication/reset_password_otp.dart';

SendCode sendCodeFromJson(String str) => SendCode.fromJson(json.decode(str));

String sendCodeToJson(SendCode data) => json.encode(data.toJson());

class SendCode {
  String success;

  SendCode({
    required this.success,
  });

  factory SendCode.fromJson(Map<String, dynamic> json) => SendCode(
        success: json["success"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
      };
}

sendEmailVerification(String email) async {
  try {
    final response = await http.post(
      Uri.parse("https://fari-jcuo.onrender.com/main/sendcode"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'email': email,
        'code_type': 'registration',
      }),
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception(response.reasonPhrase);
    }
  } catch (e) {
    print(e.toString());
    throw Exception('Failed to send email verification code: $e');
  }
}

sendPasswordResetCode(BuildContext context, email) async {
  try {
    final response = await http.post(
      Uri.parse("https://fari-jcuo.onrender.com/main/sendcode"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'email': email,
        'code_type': 'resetpassword',
      }),
    );
    if (response.statusCode == 200) {
      return Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ResetPasswordOTP()),
      );
    } else {
      print(response.statusCode);
      throw Exception(response.reasonPhrase);
    }
  } catch (e) {
    print(e.toString());
    throw Exception('Failed to send email verification code: $e');
  }
}
