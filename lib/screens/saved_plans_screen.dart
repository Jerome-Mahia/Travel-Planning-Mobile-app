import 'package:flutter/material.dart';

class SavedPlanScreen extends StatefulWidget {
  const SavedPlanScreen({super.key});

  @override
  State<SavedPlanScreen> createState() => _SavedPlanScreenState();
}

class _SavedPlanScreenState extends State<SavedPlanScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor,
      child: SafeArea(
        child: Scaffold(),
      ),
    );
  }
}
