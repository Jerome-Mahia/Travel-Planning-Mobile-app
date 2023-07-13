// To parse this JSON data, do
//
//     final fetchEveryItinerary = fetchEveryItineraryFromJson(jsonString);

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:travel_planner_app_cs_project/models/login.dart';

FetchEveryItinerary fetchEveryItineraryFromJson(String str) =>
    FetchEveryItinerary.fromJson(json.decode(str));

String fetchEveryItineraryToJson(FetchEveryItinerary data) =>
    json.encode(data.toJson());

class FetchEveryItinerary {
  List<Itinerary> itineraries;
  List<dynamic> collaborating;

  FetchEveryItinerary({
    required this.itineraries,
    required this.collaborating,
  });

  factory FetchEveryItinerary.fromJson(Map<String, dynamic> json) =>
      FetchEveryItinerary(
        itineraries: List<Itinerary>.from(
            json["itineraries"].map((x) => Itinerary.fromJson(x))),
        collaborating: List<dynamic>.from(json["collaborating"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "itineraries": List<dynamic>.from(itineraries.map((x) => x.toJson())),
        "collaborating": List<dynamic>.from(collaborating.map((x) => x)),
      };
}

class Itinerary {
  int id;
  String title;
  String notes;
  int budget;
  String destination;
  DateTime startDate;
  DateTime endDate;
  DateTime createdAt;
  int tokens;
  DateTime updatedAt;
  int owner;
  dynamic updatedBy;
  List<dynamic> collaborators;

  Itinerary({
    required this.id,
    required this.title,
    required this.notes,
    required this.budget,
    required this.destination,
    required this.startDate,
    required this.endDate,
    required this.createdAt,
    required this.tokens,
    required this.updatedAt,
    required this.owner,
    this.updatedBy,
    required this.collaborators,
  });

  factory Itinerary.fromJson(Map<String, dynamic> json) => Itinerary(
        id: json["id"],
        title: json["title"],
        notes: json["notes"],
        budget: json["budget"],
        destination: json["destination"],
        startDate: DateTime.parse(json["start_date"]),
        endDate: DateTime.parse(json["end_date"]),
        createdAt: DateTime.parse(json["created_at"]),
        tokens: json["tokens"],
        updatedAt: DateTime.parse(json["updated_at"]),
        owner: json["owner"],
        updatedBy: json["updated_by"],
        collaborators: List<dynamic>.from(json["collaborators"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "notes": notes,
        "budget": budget,
        "destination": destination,
        "start_date":
            "${startDate.year.toString().padLeft(4, '0')}-${startDate.month.toString().padLeft(2, '0')}-${startDate.day.toString().padLeft(2, '0')}",
        "end_date":
            "${endDate.year.toString().padLeft(4, '0')}-${endDate.month.toString().padLeft(2, '0')}-${endDate.day.toString().padLeft(2, '0')}",
        "created_at": createdAt.toIso8601String(),
        "tokens": tokens,
        "updated_at": updatedAt.toIso8601String(),
        "owner": owner,
        "updated_by": updatedBy,
        "collaborators": List<dynamic>.from(collaborators.map((x) => x)),
      };
}

Future<List<Itinerary>> getEveryItinerary(BuildContext context) async {
  try {
    final Accesstoken = await retrieveToken();
    final response = await http.get(
      Uri.parse("https://fari-jcuo.onrender.com/main/create-get-itinerary"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${Accesstoken.toString()}',
      },
    );
    if (response.statusCode == 200) {
      final List result = jsonDecode(response.body)['itineraries'];
      return result.map((itinerary) => Itinerary.fromJson(itinerary)).toList();
    } else {
      throw Exception('Failed to retrieve all the itineraries');
    }
  } catch (e) {
    print(e.toString());
    throw Exception('Failed to retrieve all the itineraries: $e');
  }
}
