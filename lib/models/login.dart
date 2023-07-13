// To parse this JSON data, do
//
//     final registration = registrationFromJson(jsonString);

import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:travel_planner_app_cs_project/models/get_user_details.dart';
import 'package:travel_planner_app_cs_project/widgets/bottom_navbar_widget.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

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

// Create storage
final storage = FlutterSecureStorage();

Future<String> retrieveToken() async {
  String? value = await storage.read(key: 'access token');
  return value.toString();
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
      var token = jsonDecode(response.body)['access'];
      
      // Write value
      await storage.write(key: 'access token', value: token);

      return Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const BottomNavBar()),
        (Route<dynamic> route) => false,
      );
    } else {
      return SnackBar(content: Text('Login timed out'));
    }
  } catch (e) {
    print(e.toString());
    throw Exception('Failed to send email verification code: $e');
  }
}
