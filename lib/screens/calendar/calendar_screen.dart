import 'package:flutter/material.dart';

class TripCalendarScreen extends StatefulWidget {
  const TripCalendarScreen({super.key});

  @override
  State<TripCalendarScreen> createState() => _TripCalendarScreenState();
}

class _TripCalendarScreenState extends State<TripCalendarScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar'),
      ),
      body: const Center(
        child: Text('Calendar'),
      ),
    );
  }
}