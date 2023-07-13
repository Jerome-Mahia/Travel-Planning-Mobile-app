// To parse this JSON data, do
//
//     final deleteItinerary = deleteItineraryFromJson(jsonString);

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:travel_planner_app_cs_project/models/login.dart';

DeleteItinerary deleteItineraryFromJson(String str) => DeleteItinerary.fromJson(json.decode(str));

String deleteItineraryToJson(DeleteItinerary data) => json.encode(data.toJson());

class DeleteItinerary {
    String success;

    DeleteItinerary({
        required this.success,
    });

    factory DeleteItinerary.fromJson(Map<String, dynamic> json) => DeleteItinerary(
        success: json["success"],
    );

    Map<String, dynamic> toJson() => {
        "success": success,
    };
}
deleteItinerary(BuildContext context) async {
  try {
    final Accesstoken = await retrieveToken();
    final response = await http.delete(
      Uri.parse("https://fari-jcuo.onrender.com/main/delete-itinerary/{id}"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${Accesstoken.toString()}',
      },
    );
    if (response.statusCode == 200) {
      return SnackBar(content: Text('Successfully deleted itinerary'));
    } else {
      return SnackBar(content: Text('Unable to delete itinerary'));
    }
  } catch (e) {
    print(e.toString());
    throw Exception('Failed to retrieve user details: $e');
  }
}