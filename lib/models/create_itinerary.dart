// To parse this JSON data, do
//
//     final createItinerary = createItineraryFromJson(jsonString);
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:travel_planner_app_cs_project/models/login.dart';
import 'package:travel_planner_app_cs_project/screens/planning/trip_detail_screen.dart';

// To parse this JSON data, do
//
//     final createItinerary = createItineraryFromJson(jsonString);

CreateItinerary createItineraryFromJson(String str) =>
    CreateItinerary.fromJson(json.decode(str));

String createItineraryToJson(CreateItinerary data) =>
    json.encode(data.toJson());

class CreateItinerary {
  String success;

  CreateItinerary({
    required this.success,
  });

  factory CreateItinerary.fromJson(Map<String, dynamic> json) =>
      CreateItinerary(
        success: json["success"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
      };
}

createItinerary(
    BuildContext context,
    String title,
    String notes,
    String destination,
    String startDate,
    String endDate,
    List<int> collaborators,
    int budget,
    String ageRestriction,
    String funLevel) async {
  try {
    final Accesstoken = await retrieveToken();
    final response = await http.post(
      Uri.parse("https://fari-jcuo.onrender.com/main/create-get-itinerary"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${Accesstoken.toString()}',
      },
      body: jsonEncode(<String, dynamic>{
        "title": title,
        "notes": notes,
        "destination": destination,
        "start_date": startDate,
        "end_date": endDate,
        "collaborators": collaborators,
        "budget": budget,
        "age": ageRestriction,
        "fun": funLevel,
      }),
    );
    print(Accesstoken.toString());
    if (response.statusCode == 201) {
      return null;
    } else {
      print(response.statusCode);
      throw SnackBar(content: Text('Unable to create itinerary'));
    }
  } catch (e) {
    print(e.toString());
    throw Exception('Failed to send email verification code: $e');
  }
}
