// To parse this JSON data, do
//
//     final editUserDetails = editUserDetailsFromJson(jsonString);

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:travel_planner_app_cs_project/models/login.dart';

EditUserDetails getUserDetailsFromJson(String str) =>
    EditUserDetails.fromJson(json.decode(str));

String getUserDetailsToJson(EditUserDetails data) => json.encode(data.toJson());

class EditUserDetails {
  String name;
  String email;
  String phone;
  DateTime dob;
  String image;
  int id;

  EditUserDetails({
    required this.name,
    required this.email,
    required this.phone,
    required this.dob,
    required this.image,
    required this.id,
  });

  factory EditUserDetails.fromJson(Map<String, dynamic> json) => EditUserDetails(
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

editUserDetails(BuildContext context, String name, String phone, DateTime dob,String image, int id) async {
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
      return List<EditUserDetails>.from(
          body.map((x) => EditUserDetails.fromJson(x)));
    } else {
      return SnackBar(content: Text('Unable to edi user details'));
    }
  } catch (e) {
    print(e.toString());
    throw Exception('Failed to edit user details: $e');
  }
}