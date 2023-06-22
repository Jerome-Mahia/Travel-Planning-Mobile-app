// To parse this JSON data, do
//
//     final registration = registrationFromJson(jsonString);

import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
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

loginUser(BuildContext context, String email, String password) async {
  try {
    final response = await http.post(
      Uri.parse("https://fari-jcuo.onrender.com/api/token/"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'email': email,
        'password': password,
      }),
    );
    if (response.statusCode == 200) {
      return Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const BottomNavBar()),
      );
    } else {
      throw Exception('Failed to login user');
    }
  } catch (e) {
    print(e.toString());
    throw Exception('Failed to send email verification code: $e');
  }
}
