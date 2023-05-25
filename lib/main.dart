import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_planner_app_cs_project/screens/authentication/login_screen.dart';
import 'package:travel_planner_app_cs_project/screens/authentication/sign_in_options.dart';

import 'widgets/navigation.dart';

void main() {
  runApp(ProviderScope(child: const MyApp()));
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
        colorScheme: ColorScheme.light().copyWith(
          surface: Colors.white, // Specify your desired surface color here
        ),
        primaryColor: const Color.fromRGBO(255, 69, 91, 1),
      ),
      home: SignInOptionScreen(),
    );
  }
}
