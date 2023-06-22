import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:travel_planner_app_cs_project/screens/home/feed_screen.dart';
import 'package:travel_planner_app_cs_project/utils/authentication.dart';

class google_sign_in_button extends StatefulWidget {
  const google_sign_in_button({
    super.key,
  });

  @override
  State<google_sign_in_button> createState() => _google_sign_in_buttonState();
}

class _google_sign_in_buttonState extends State<google_sign_in_button> {
  bool _isSigningIn = false;

  @override
  Widget build(BuildContext context) {
    return _isSigningIn
        ? CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
          )
        : Center(
            child: InkWell(
              onTap: () async {
                setState(() {
                  _isSigningIn = true;
                });
                User? user =
                    await Authentication.signInWithGoogle(context: context);

                setState(() {
                  _isSigningIn = false;
                });

                if (user != null) {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => FeedScreen(),
                    ),
                  );
                }
              },
              child: Container(
                //width: 100.0,
                height: 55.0,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: Colors.grey.withOpacity(0.8),
                    width: 0.5,
                  ),
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                      child: Image.asset(
                        'assets/icons/google.png',
                        height: 30,
                        width: 30,
                      ),
                    ),
                    const Center(
                      child: Text(
                        'Sign in with Google',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
