import 'package:flutter/material.dart';

class BudgetTab extends StatefulWidget {
  const BudgetTab({super.key});

  @override
  State<BudgetTab> createState() => _BudgetTabState();
}

class _BudgetTabState extends State<BudgetTab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
        child: Text("Budget"),
      ),
    );
  }
}