// To parse this JSON data, do
//
//     final searchUsers = searchUsersFromJson(jsonString);

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:travel_planner_app_cs_project/models/login.dart';

SearchUsers searchUsersFromJson(String str) => SearchUsers.fromJson(json.decode(str));

String searchUsersToJson(SearchUsers data) => json.encode(data.toJson());

class SearchUsers {
    List<User> users;

    SearchUsers({
        required this.users,
    });

    factory SearchUsers.fromJson(Map<String, dynamic> json) => SearchUsers(
        users: List<User>.from(json["users"].map((x) => User.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "users": List<dynamic>.from(users.map((x) => x.toJson())),
    };
}

class User {
    String name;
    String email;
    String phone;
    DateTime dob;
    String image;
    int id;

    User({
        required this.name,
        required this.email,
        required this.phone,
        required this.dob,
        required this.image,
        required this.id,
    });

    factory User.fromJson(Map<String, dynamic> json) => User(
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
        "dob": "${dob.year.toString().padLeft(4, '0')}-${dob.month.toString().padLeft(2, '0')}-${dob.day.toString().padLeft(2, '0')}",
        "image": image,
        "id": id,
    };
}
searchUser(BuildContext context, String search) async {
  try {
    final Accesstoken = await retrieveToken();
    final response = await http.post(
      Uri.parse("https://fari-jcuo.onrender.com/main/search-users"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${Accesstoken.toString()}',
      },
      body: jsonEncode(<String, dynamic>{
        'search': search,
      }),
    );
    if (response.statusCode == 200) {
      final List result = jsonDecode(response.body)['users'];
      return result.map(((e) => User.fromJson(e))).toList();
    } else {
      return SnackBar(content: Text('Unable to find user'));
    }
  } catch (e) {
    print(e.toString());
    throw Exception('Failed to send email verification code: $e');
  }
}