import 'package:flutter/material.dart';

class SavedPlanScreen extends StatefulWidget {
  const SavedPlanScreen({super.key});

  @override
  State<SavedPlanScreen> createState() => _SavedPlanScreenState();
}

class _SavedPlanScreenState extends State<SavedPlanScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Center(child: Text('Saved Plans')),
        ),
        body: const Center(
          child: Text('Saved Plans'),
        ),
      ),
    );
  }
}
