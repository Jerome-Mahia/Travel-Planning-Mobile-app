import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:travel_planner_app_cs_project/screens/authentication/login_screen.dart';
import 'package:travel_planner_app_cs_project/widgets/bottom_navbar_widget.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  List<bool> isSelected = [false, false];
  List<bool> togglevalue = [false, false];
  bool isDark = false;

  // Send the isDarkMode value to shared preferences
  // setDarkModeBool(bool isDarkMode) async {
  //   SharedPreferences mode = await SharedPreferences.getInstance();
  //   await mode.setBool('isDarkMode', isDarkMode);
  // }

  // @override
  // void initState() {
  //   getDarkModeBool();
  //   super.initState();
  // }

  // getDarkModeBool() async {
  //   SharedPreferences mode = await SharedPreferences.getInstance();
  //   bool isDarkMode = mode.getBool('isDarkMode') ?? false;
  //   return isDarkMode;
  // }
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            surfaceTintColor: Colors.white,
            centerTitle: true,
            title: const Text('Settings'),
          ),
          body: SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Container(
                      constraints: BoxConstraints(
                          minWidth: MediaQuery.of(context).size.width * 0.93,
                          maxWidth: MediaQuery.of(context).size.width * 0.93,
                          minHeight: 110,
                          maxHeight: 110),
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                            color: Colors.blueGrey.withOpacity(0.5), width: 1),
                      ),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Wrap(
                              children: [
                                CircleAvatar(
                                  radius: 33,
                                  backgroundImage: AssetImage(
                                    "assets/images/joseph-gonzalez-iFgRcqHznqg-unsplash.jpg",
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "John Doe",
                                      style: TextStyle(
                                        //account titles
                                        color: Colors.grey.shade800,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      "johndoe@gmail.com",
                                      style: TextStyle(
                                        //account titles
                                        color: Colors.grey.shade800,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              color: Theme.of(context).iconTheme.color,
                              size: 25.0,
                            ),
                          ]),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Divider(
                        color: Colors.blueGrey.withOpacity(0.2),
                        thickness: 1,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Settings & Preferences',
                          style: TextStyle(
                            //account page subtitles
                            fontSize: 17.0,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        GestureDetector(
                          onTap: () {
                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (context) => ()));
                          },
                          child: Container(
                            constraints: BoxConstraints(
                                minWidth:
                                    MediaQuery.of(context).size.width * 0.93,
                                maxWidth:
                                    MediaQuery.of(context).size.width * 0.93,
                                minHeight: 55,
                                maxHeight: 55),
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: Colors.blueGrey.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(16)),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Wrap(
                                    children: [
                                      Icon(
                                        Icons.notifications,
                                        size: 22,
                                        color:
                                            Theme.of(context).iconTheme.color,
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        "Notifications",
                                        style: TextStyle(
                                          //account titles
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    color: Theme.of(context).iconTheme.color,
                                    size: 25.0,
                                  ),
                                ]),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Container(
                          constraints: BoxConstraints(
                              minWidth:
                                  MediaQuery.of(context).size.width * 0.93,
                              maxWidth:
                                  MediaQuery.of(context).size.width * 0.93,
                              minHeight: 55,
                              maxHeight: 55),
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: Colors.blueGrey.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(16)),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Wrap(
                                  children: [
                                    Icon(
                                      Icons.subscriptions,
                                      size: 22,
                                      color: Theme.of(context).iconTheme.color,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      "Subscriptions",
                                      style: TextStyle(
                                        //account titles
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  color: Theme.of(context).iconTheme.color,
                                  size: 25.0,
                                ),
                              ]),
                        )
                      ],
                    ),
                    SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Container(
                          constraints: BoxConstraints(
                              minWidth:
                                  MediaQuery.of(context).size.width * 0.93,
                              maxWidth:
                                  MediaQuery.of(context).size.width * 0.93,
                              minHeight: 55,
                              maxHeight: 55),
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: Colors.blueGrey.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(16)),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Wrap(
                                  children: [
                                    Icon(
                                      Icons.dark_mode,
                                      size: 22,
                                      color: Theme.of(context).iconTheme.color,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      "Dark Mode",
                                      style: TextStyle(
                                        //account titles
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                                CupertinoSwitch(
                                  value: isDark,
                                  onChanged: (value) {
                                    setState(() {
                                      isDark = value;
                                      // ref
                                      //     .read(darkModeProvider.notifier)
                                      //     .state = value;
                                      // setDarkModeBool(
                                      //     value); // Update the isDarkMode value in shared preferences
                                    });
                                  },
                                  thumbColor: isDark
                                      ? Colors.black
                                      : Color.fromARGB(232, 255, 255, 255),
                                  trackColor: Colors.black,
                                  activeColor:
                                      Color.fromARGB(232, 255, 255, 255),
                                ),
                              ]),
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Divider(
                        color: Colors.blueGrey.withOpacity(0.2),
                        thickness: 1,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Support & Help',
                          style: TextStyle(
                            //account page subtitles
                            fontSize: 17.0,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Container(
                          constraints: BoxConstraints(
                              minWidth:
                                  MediaQuery.of(context).size.width * 0.93,
                              maxWidth:
                                  MediaQuery.of(context).size.width * 0.93,
                              minHeight: 55,
                              maxHeight: 55),
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: Colors.blueGrey.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(16)),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Wrap(
                                  children: [
                                    Icon(
                                      Icons.security,
                                      size: 22,
                                      color: Theme.of(context).iconTheme.color,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      "Privacy and Security",
                                      style: TextStyle(
                                        //account titles
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  color: Theme.of(context).iconTheme.color,
                                  size: 25.0,
                                ),
                              ]),
                        )
                      ],
                    ),
                    SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Container(
                          constraints: BoxConstraints(
                              minWidth:
                                  MediaQuery.of(context).size.width * 0.93,
                              maxWidth:
                                  MediaQuery.of(context).size.width * 0.93,
                              minHeight: 55,
                              maxHeight: 55),
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: Colors.blueGrey.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(16)),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Wrap(
                                  children: [
                                    Icon(
                                      Icons.info,
                                      size: 22,
                                      color: Theme.of(context).iconTheme.color,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      "About Us",
                                      style: TextStyle(
                                        //account titles
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  color: Theme.of(context).iconTheme.color,
                                  size: 25.0,
                                ),
                              ]),
                        )
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        GestureDetector(
                          onTap: () {
                            showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text(
                                      'Are you sure you want to log out?',
                                      textAlign: TextAlign.center,
                                    ),
                                    content: Text(
                                        'Logging out will end your current session and you will need to sign in again to access your account.'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text('Cancel',
                                            style:
                                                TextStyle(color: Colors.black)),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          void resetAppState(
                                              BuildContext context) {
                                            Navigator.pushAndRemoveUntil(
                                              context,
                                              MaterialPageRoute(
                                                  builder:
                                                      (BuildContext context) =>
                                                          LoginScreen()),
                                              (Route<dynamic> route) => false,
                                            );
                                          }

                                          resetAppState(context);
                                        },
                                        child: Text('Log Out',
                                            style:
                                                TextStyle(color: Colors.red)),
                                      ),
                                    ],
                                  );
                                });
                          },
                          child: Container(
                            constraints: BoxConstraints(
                                minWidth:
                                    MediaQuery.of(context).size.width * 0.93,
                                maxWidth:
                                    MediaQuery.of(context).size.width * 0.93,
                                minHeight: 55,
                                maxHeight: 55),
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(16)),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Wrap(
                                    children: [
                                      const Icon(
                                        Icons.logout,
                                        size: 22,
                                        color:
                                            Color.fromARGB(232, 255, 255, 255),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        "Logout",
                                        style: TextStyle(
                                          color: Color.fromARGB(
                                              232, 255, 255, 255),
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    color: Color.fromARGB(232, 255, 255, 255),
                                    size: 25.0,
                                  ),
                                ]),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
