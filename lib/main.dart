import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_planner_app_cs_project/screens/authentication/login_screen.dart';
import 'package:travel_planner_app_cs_project/screens/authentication/sign_in_options.dart';

import 'widgets/bottom_navbar_widget.dart';

Future<void> main() async {
  await dotenv.load(fileName: '.env');
  WidgetsFlutterBinding.ensureInitialized();
  runApp(ProviderScope(child: const MyApp()));
}

final hideNavBarProvider = StateProvider((ref) => false);
final accountCreationProvider = StateProvider((ref) => false);
final datePickedProvider = StateProvider((ref) => '');
final otpControllerProvider = StateProvider((ref) => '');
final emailProvider = StateProvider((ref) => '');
final playTimeProvider = StateProvider((ref) => '');
final songUriProvider = StateProvider((ref) => '');

final usernameProvider = StateProvider((ref) => '');
final useremailProvider = StateProvider((ref) => '');
final userphoneProvider = StateProvider((ref) => '');
final useridProvider = StateProvider((ref) => '');
final userimageProvider = StateProvider((ref) => 'null');
final userdobProvider = StateProvider((ref) => '');

final notesProvider = StateProvider((ref) => jsonDecode('[]'));

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
