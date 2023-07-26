// To parse this JSON data, do
//
//     final searchFriends = searchFriendsFromJson(jsonString);

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:travel_planner_app_cs_project/models/login.dart';

SearchFriends searchFriendsFromJson(String str) =>
    SearchFriends.fromJson(json.decode(str));

String searchFriendsToJson(SearchFriends data) => json.encode(data.toJson());

class SearchFriends {
  List<User> users;

  SearchFriends({
    required this.users,
  });

  factory SearchFriends.fromJson(Map<String, dynamic> json) => SearchFriends(
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
  dynamic dob;
  dynamic image;
  int id;

  User({
    required this.name,
    required this.email,
    required this.phone,
    this.dob,
    this.image,
    required this.id,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        name: json["name"],
        email: json["email"],
        phone: json["phone"],
        dob: json["dob"],
        image: json["image"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "email": email,
        "phone": phone,
        "dob": dob,
        "image": image,
        "id": id,
      };
}

Future<List<User>> searchFriends(BuildContext context, String name) async {
  try {
    final Accesstoken = await retrieveToken();
    final response = await http.post(
      Uri.parse("https://fari-jcuo.onrender.com/main/search-users"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${Accesstoken.toString()}',
      },
      body: jsonEncode(<String, String>{
        'search': name,
      }),
    );
    if (response.statusCode == 200) {
      final List result = jsonDecode(response.body)['users'];
      return result.map(((e) => User.fromJson(e))).toList();
    } else {
      throw Exception('Failed to retrieve friend details');
    }
  } catch (e) {
    print(e.toString());
    throw Exception('Failed to retrieve friend details: $e');
  }
}

List<User> collaborator_list = [];
