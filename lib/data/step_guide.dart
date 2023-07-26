import 'package:flutter/material.dart';
import 'package:travel_planner_app_cs_project/screens/planning/note_editing_screen.dart';
import 'package:travel_planner_app_cs_project/screens/planning/trip_detail_screen.dart';

class StepGuide {
  final String title;
  final String description;
  final Widget screen;

  StepGuide({
    required this.title,
    required this.description,
    required this.screen,
  });
}

// final _guide1 = StepGuide(
//     title: 'Add a note', description: 'Jot down anything about your trip', screen: NoteEditingScreen());

// final _guide2 = StepGuide(
//     title: 'Add a flight ticket',
//     description: 'Save your flight tickets in one place', screen: TripDetailScreen());

// final _guide3 = StepGuide(
//     title: 'Add a ticket',
//     description: 'Save your bus or any other ticket in one place', screen: TripDetailScreen());

List<StepGuide> guides = [
  // _guide1,
  // _guide2,
  // _guide3,
];
