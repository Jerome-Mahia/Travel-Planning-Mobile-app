import 'package:flutter/material.dart';
import 'package:travel_planner_app_cs_project/data/step_guide.dart';

class OverviewTab extends StatefulWidget {
  const OverviewTab({super.key});

  @override
  State<OverviewTab> createState() => _OverviewTabState();
}

class _OverviewTabState extends State<OverviewTab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
        child: Text("Overview"),
      ),
    );
  }
}
