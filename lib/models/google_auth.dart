import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:travel_planner_app_cs_project/widgets/bottom_navbar_widget.dart';

GoogleAuth registrationFromJson(String str) =>
    GoogleAuth.fromJson(json.decode(str));

String registrationToJson(GoogleAuth data) => json.encode(data.toJson());

class GoogleAuth {
  String refresh;
  String access;

  GoogleAuth({
    required this.refresh,
    required this.access,
  });

  factory GoogleAuth.fromJson(Map<String, dynamic> json) => GoogleAuth(
        refresh: json["refresh"],
        access: json["access"],
      );

  Map<String, dynamic> toJson() => {
        "refresh": refresh,
        "access": access,
      };
}

registerGoogleAcc(BuildContext context, String email, String name) async {
  try {
    final response = await http.post(
      Uri.parse("https://fari-jcuo.onrender.com/api/token/"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'email': email,
        'name': name,
      }),
    );
    if (response.statusCode == 200) {
      SnackBar(content: Text('Login successful'));
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
