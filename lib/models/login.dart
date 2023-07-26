// To parse this JSON data, do
//
//     final registration = registrationFromJson(jsonString);

import 'dart:convert';
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


