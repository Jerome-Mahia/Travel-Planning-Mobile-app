// To parse this JSON data, do
//
//     final getUserDetails = getUserDetailsFromJson(jsonString);

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:travel_planner_app_cs_project/models/login.dart';

GetUserDetails getUserDetailsFromJson(String str) =>
    GetUserDetails.fromJson(json.decode(str));

String getUserDetailsToJson(GetUserDetails data) => json.encode(data.toJson());

class GetUserDetails {
  String name;
  String email;
  String phone;
  DateTime dob;
  String image;
  int id;

  GetUserDetails({
    required this.name,
    required this.email,
    required this.phone,
    required this.dob,
    required this.image,
    required this.id,
  });

  factory GetUserDetails.fromJson(Map<String, dynamic> json) => GetUserDetails(
        name: json["name"],
        email: json["email"],
        phone: json["phone"],
        dob: DateTime.parse(json["dob"]),
        image: json["image"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "email": email,
        "phone": phone,
        "dob":
            "${dob.year.toString().padLeft(4, '0')}-${dob.month.toString().padLeft(2, '0')}-${dob.day.toString().padLeft(2, '0')}",
        "image": image,
        "id": id,
      };
}

Future<GetUserDetails> getUserDetails(BuildContext context) async {
  try {
    final Accesstoken = await retrieveToken();
    final response = await http.get(
      Uri.parse("https://fari-jcuo.onrender.com/main/user-details"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${Accesstoken.toString()}',
      },
    );
    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      return GetUserDetails.fromJson(result);
    } else {
      throw Exception('Failed to retrieve user details');
    }
  } catch (e) {
    print(e.toString());
    throw Exception('Failed to retrieve user details: $e');
  }
}
