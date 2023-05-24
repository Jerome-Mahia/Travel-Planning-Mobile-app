import 'package:flutter/material.dart';

class PlanningFormScreen extends StatefulWidget {
  const PlanningFormScreen({super.key});

  @override
  State<PlanningFormScreen> createState() => _PlanningFormScreenState();
}

class _PlanningFormScreenState extends State<PlanningFormScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Planning Form'),
        ),
        body: const Center(
          child: Text('Planning Form'),
        ),
      ),
    );
  }
}