import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:travel_planner_app_cs_project/models/login.dart';

// To parse this JSON data, do
//
//     final fetchItineraryDetails = fetchItineraryDetailsFromJson(jsonString);

import 'dart:convert';

FetchItineraryDetails fetchItineraryDetailsFromJson(String str) =>
    FetchItineraryDetails.fromJson(json.decode(str));

String fetchItineraryDetailsToJson(FetchItineraryDetails data) =>
    json.encode(data.toJson());

class FetchItineraryDetails {
  Itinerary itinerary;
  List<dynamic> collaborators;
  List<Day> days;

  FetchItineraryDetails({
    required this.itinerary,
    required this.collaborators,
    required this.days,
  });

  factory FetchItineraryDetails.fromJson(Map<String, dynamic> json) =>
      FetchItineraryDetails(
        itinerary: Itinerary.fromJson(json["itinerary"]),
        collaborators: List<dynamic>.from(json["collaborators"].map((x) => x)),
        days: List<Day>.from(json["days"].map((x) => Day.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "itinerary": itinerary.toJson(),
        "collaborators": List<dynamic>.from(collaborators.map((x) => x)),
        "days": List<dynamic>.from(days.map((x) => x.toJson())),
      };
}

class Day {
  int id;
  DateTime date;
  String name;
  String morningActivity;
  String afternoonActivity;
  String eveningActivity;
  int morningBudget;
  int afternoonBudget;
  int eveningBudget;
  double morningLat;
  double morningLong;
  double afternoonLat;
  double afternoonLong;
  double eveningLat;
  double eveningLong;
  int itinerary;

  Day({
    required this.id,
    required this.date,
    required this.name,
    required this.morningActivity,
    required this.afternoonActivity,
    required this.eveningActivity,
    required this.morningBudget,
    required this.afternoonBudget,
    required this.eveningBudget,
    required this.morningLat,
    required this.morningLong,
    required this.afternoonLat,
    required this.afternoonLong,
    required this.eveningLat,
    required this.eveningLong,
    required this.itinerary,
  });

  factory Day.fromJson(Map<String, dynamic> json) => Day(
        id: json["id"],
        date: DateTime.parse(json["date"]),
        name: json["name"],
        morningActivity: json["morning_activity"],
        afternoonActivity: json["afternoon_activity"],
        eveningActivity: json["evening_activity"],
        morningBudget: json["morning_budget"],
        afternoonBudget: json["afternoon_budget"],
        eveningBudget: json["evening_budget"],
        morningLat: json["morning_lat"]?.toDouble(),
        morningLong: json["morning_long"]?.toDouble(),
        afternoonLat: json["afternoon_lat"]?.toDouble(),
        afternoonLong: json["afternoon_long"]?.toDouble(),
        eveningLat: json["evening_lat"]?.toDouble(),
        eveningLong: json["evening_long"]?.toDouble(),
        itinerary: json["itinerary"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "date":
            "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
        "name": name,
        "morning_activity": morningActivity,
        "afternoon_activity": afternoonActivity,
        "evening_activity": eveningActivity,
        "morning_budget": morningBudget,
        "afternoon_budget": afternoonBudget,
        "evening_budget": eveningBudget,
        "morning_lat": morningLat,
        "morning_long": morningLong,
        "afternoon_lat": afternoonLat,
        "afternoon_long": afternoonLong,
        "evening_lat": eveningLat,
        "evening_long": eveningLong,
        "itinerary": itinerary,
      };
}

class Itinerary {
  int id;
  String title;
  String notes;
  String destination;
  int budget;
  DateTime starDate;
  DateTime endDate;
  String updatedAt;
  String updatedBy;

  Itinerary({
    required this.id,
    required this.title,
    required this.notes,
    required this.destination,
    required this.budget,
    required this.starDate,
    required this.endDate,
    required this.updatedAt,
    required this.updatedBy,
  });

  factory Itinerary.fromJson(Map<String, dynamic> json) => Itinerary(
        id: json["id"],
        title: json["title"],
        notes: json["notes"],
        destination: json["destination"],
        budget: json["budget"],
        starDate: DateTime.parse(json["star_date"]),
        endDate: DateTime.parse(json["end_date"]),
        updatedAt: json["updated_at"],
        updatedBy: json["updated_by"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "notes": notes,
        "destination": destination,
        "budget": budget,
        "star_date":
            "${starDate.year.toString().padLeft(4, '0')}-${starDate.month.toString().padLeft(2, '0')}-${starDate.day.toString().padLeft(2, '0')}",
        "end_date":
            "${endDate.year.toString().padLeft(4, '0')}-${endDate.month.toString().padLeft(2, '0')}-${endDate.day.toString().padLeft(2, '0')}",
        "updated_at": updatedAt,
        "updated_by": updatedBy,
      };
}

Future<List<Day>> getItineraryDetails(BuildContext context, String id) async {
  try {
    final Accesstoken = await retrieveToken();
    final response = await http.get(
      Uri.parse(
          "https://fari-jcuo.onrender.com/main/get-edit-itinerary-details/$id"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${Accesstoken.toString()}',
      },
    );
    if (response.statusCode == 200) {
      // for (final day in days) {
      //   final date = day['date'];
      //   final morningActivity = day['morning_activity'];
      //   final afternoonActivity = day['afternoon_activity'];
      //   final eveningActivity = day['evening_activity'];

      //   // Perform necessary operations with the extracted data
      //   print('Date: $date');
      //   print('Morning Activity: $morningActivity');
      //   print('Afternoon Activity: $afternoonActivity');
      //   print('Evening Activity: $eveningActivity');
      // }
      
      final List result = jsonDecode(response.body)['days'];
      print(result);
      return result.map((days) => Day.fromJson(days)).toList();
    } else {
      return [];
    }
  } catch (e) {
    print(e.toString());
    throw Exception('Failed to fetch itinerary details: $e');
  }
}