import 'package:flutter/material.dart';

class ItineraryTab extends StatefulWidget {
  const ItineraryTab({super.key});

  @override
  State<ItineraryTab> createState() => _ItineraryTabState();
}

class _ItineraryTabState extends State<ItineraryTab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
        child: Text("Itinerary"),
      ),
    );
  }
}