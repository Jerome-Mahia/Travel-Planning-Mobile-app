import 'package:flutter/material.dart';
import 'package:travel_planner_app_cs_project/screens/login_screen.dart';

import 'screens/navigation.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Travel App Flutter U.I',
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Nunito',
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: const Color.fromRGBO(255, 69, 91, 1),
        ),
        primaryColor: const Color.fromRGBO(255, 69, 91, 1),
      ),
      home: LoginScreen(),
    );
  }
}
