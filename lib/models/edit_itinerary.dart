// To parse this JSON data, do
//
//     final editItinerary = editItineraryFromJson(jsonString);

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:travel_planner_app_cs_project/models/login.dart';

EditItinerary editItineraryFromJson(String str) =>
    EditItinerary.fromJson(json.decode(str));

String editItineraryToJson(EditItinerary data) => json.encode(data.toJson());

class EditItinerary {
  String success;

  EditItinerary({
    required this.success,
  });

  factory EditItinerary.fromJson(Map<String, dynamic> json) => EditItinerary(
        success: json["success"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
      };
}

editItineraryDay(
  BuildContext context,
  String id,
  String name,
  String morningActivity,
  String afternoonActivity,
  String eveningActivity,
  int morningBudget,
  int afternoonBudget,
  int eveningBudget,
  double morningLat,
  double morningLong,
  double afternoonLat,
  double afternoonLong,
  double eveningLat,
  double eveningLong,
) async {
  try {
    final Accesstoken = await retrieveToken();
    final response = await http.post(
      Uri.parse("https://fari-jcuo.onrender.com/main/edit-itinerary-day/$id"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${Accesstoken.toString()}',
      },
      body: jsonEncode(<String, String>{
        'name': name,
        'morningActivity': morningActivity,
        'afternoonActivity': afternoonActivity,
        'eveningActivity': eveningActivity,
        'morningBudget': morningBudget.toString(),
        'afternoonBudget': afternoonBudget.toString(),
        'eveningBudget': eveningBudget.toString(),
        'morningLat': morningLat.toString(),
        'morningLong': morningLong.toString(),
        'afternoonLat': afternoonLat.toString(),
        'afternoonLong': afternoonLong.toString(),
        'eveningLat': eveningLat.toString(),
        'eveningLong': eveningLong.toString(),
      }),
    );
    if (response.statusCode == 200) {
      print(true);
      return true;
    } else {
      return SnackBar(content: Text('Unable to edit itinerary details'));
    }
  } catch (e) {
    print(e.toString());
    throw Exception('Failed to edit itinerary details: $e');
  }
}
