import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Expenses {
  final Map<String, dynamic> iconItem;
  final String title;
  final int amount;
  final String type;

  Expenses(
    this.iconItem,
    this.title,
    this.amount,
    this.type,
  );
}

final _expense1 = Expenses(
  {'icon': Icons.flight_takeoff},
  'Kenya Airways',
  12000,
  'Flights',
);
final _expense2 = Expenses(
  {'icon': Icons.hotel},
  'Sarova Hotel',
  20000,
  'Accomodation',
);
final _expense3 = Expenses(
  {'icon': Icons.restaurant},
  'Spurs Restaurant',
  5000,
  'Food',
);
final _expense4 = Expenses(
  {'icon': Icons.local_activity},
  'Uhuru Park',
  100,
  'Activities',
);
final _expense5 = Expenses(
  {'icon': Icons.local_taxi},
  'Taxi',
  500,
  'Transport',
);

List<Expenses> expense_list = [
  _expense1,
  _expense2,
  _expense3,
  _expense4,
  _expense5,
];
