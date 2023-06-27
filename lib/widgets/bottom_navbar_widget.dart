import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_planner_app_cs_project/data/data.dart';
import 'package:travel_planner_app_cs_project/models/destination.dart';
import 'package:travel_planner_app_cs_project/screens/calendar/calendar_screen.dart';
import 'package:travel_planner_app_cs_project/screens/home/destination_screens.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:travel_planner_app_cs_project/screens/home/feed_screen.dart';
import 'package:travel_planner_app_cs_project/screens/planning/saved_plans_screen.dart';
import 'package:travel_planner_app_cs_project/screens/search/search_destination_screen.dart';
import 'package:travel_planner_app_cs_project/screens/settings/settings_screen.dart';

class BottomNavBar extends ConsumerStatefulWidget {
  const BottomNavBar({super.key});

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends ConsumerState<BottomNavBar> {
  @override
  Widget build(BuildContext context) {
    List<Widget> _buildScreens() {
      return [
        const FeedScreen(),
        const TripCalendarScreen(),
        const SearchDestinationScreen(),
        const SavedPlanScreen(),
        const SettingsScreen(),
      ];
    }

    List<PersistentBottomNavBarItem> _navBarsItems() {
      return [
        PersistentBottomNavBarItem(
          icon: const Icon(Icons.home),
          title: ("Home"),
          activeColorPrimary: Theme.of(context).primaryColor,
          inactiveColorPrimary: const Color.fromARGB(255, 10, 10, 10),
        ),
        PersistentBottomNavBarItem(
          icon: const Icon(Icons.calendar_month),
          title: ("Calendar"),
          activeColorPrimary: Theme.of(context).primaryColor,
          inactiveColorPrimary: const Color.fromARGB(255, 10, 10, 10),
        ),
        PersistentBottomNavBarItem(
          icon: const Icon(Icons.search,color: Colors.white,),
          title: ("Search"),
          activeColorPrimary: Theme.of(context).primaryColor,
        ),
        PersistentBottomNavBarItem(
          icon: const Icon(Icons.book),
          title: ("Plans"),
          activeColorPrimary: Theme.of(context).primaryColor,
          inactiveColorPrimary: const Color.fromARGB(255, 10, 10, 10),
        ),
        PersistentBottomNavBarItem(
          icon: const Icon(Icons.settings),
          title: ("Settings"),
          activeColorPrimary: Theme.of(context).primaryColor,
          inactiveColorPrimary: const Color.fromARGB(255, 10, 10, 10),
        ),
      ];
    }

    PersistentTabController controller;

    controller = PersistentTabController(initialIndex: 0);

    return WillPopScope(
      onWillPop: () async {
        return await showDialog(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(
                  'Are you sure you want to exit?',
                  textAlign: TextAlign.center,
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('No', style: TextStyle(color: Colors.black,fontSize: 20)),
                  ),
                  TextButton(
                    onPressed: () {
                      SystemNavigator.pop();
                    },
                    child: Text('Yes', style: TextStyle(color: Colors.red,fontSize: 20)),
                  ),
                ],
              );
            });
      },
      child: PersistentTabView(
        context,
        controller: controller,
        screens: _buildScreens(),
        items: _navBarsItems(),
        // hideNavigationBar: ,
        confineInSafeArea: true,
        backgroundColor: Colors.white, // Default is Colors.white.
        handleAndroidBackButtonPress: true, // Default is true.
        resizeToAvoidBottomInset:
            true, // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
        stateManagement: true, // Default is true.
        hideNavigationBarWhenKeyboardShows:
            true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
        decoration: NavBarDecoration(
          borderRadius: BorderRadius.circular(10.0),
          colorBehindNavBar: const Color.fromARGB(255, 236, 228, 228).withOpacity(0.3),
        ),
        popAllScreensOnTapOfSelectedTab: true,
        popActionScreens: PopActionScreensType.all,
        itemAnimationProperties: const ItemAnimationProperties(
          // Navigation Bar's items animation properties.
          duration: Duration(milliseconds: 400),
          curve: Curves.ease,
        ),
        screenTransitionAnimation: const ScreenTransitionAnimation(
          // Screen transition animation on change of selected tab.
          animateTabTransition: true,
          curve: Curves.ease,
          duration: Duration(milliseconds: 400),
        ),
        navBarStyle:
            NavBarStyle.style16, // Choose the nav bar style with this property.
      ),
    );
  }
}
