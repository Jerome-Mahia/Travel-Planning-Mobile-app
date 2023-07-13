import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:share_plus/share_plus.dart';
import 'package:travel_planner_app_cs_project/main.dart';
import 'package:travel_planner_app_cs_project/data/step_guide.dart';
import 'package:travel_planner_app_cs_project/models/fetch_itinerary_details.dart';
import 'package:travel_planner_app_cs_project/screens/home/feed_screen.dart';
import 'package:travel_planner_app_cs_project/screens/map/trip_map_screen.dart';
import 'package:travel_planner_app_cs_project/screens/planning/budget_screen.dart';
import 'package:travel_planner_app_cs_project/screens/planning/itinerary_screen.dart';
import 'package:travel_planner_app_cs_project/screens/planning/overview_screen.dart';
import 'package:travel_planner_app_cs_project/screens/spotify/now_playing_screen.dart';
import 'package:travel_planner_app_cs_project/screens/spotify/spotify_screen.dart';
import 'package:travel_planner_app_cs_project/widgets/bottom_navbar_widget.dart';

class TripDetailScreen extends ConsumerStatefulWidget {
  const TripDetailScreen({super.key});

  @override
  _TripDetailScreenState createState() => _TripDetailScreenState();
}

class _TripDetailScreenState extends ConsumerState<TripDetailScreen>
    with TickerProviderStateMixin {
  bool isLoading = true;
  void retrieveItinerary() {
    if(getItineraryDetails(context) == null){
      setState(() {
        isLoading = true;
      });
    }
    else{
      setState(() {
        isLoading = false;
      });
    }
    // Timer.periodic(const Duration(seconds: 4), (t) {
      // setState(() {
      //   isLoading = false; //set loading to false
      // });
    //   t.cancel(); //stops the timer
    // });
  }

  late AnimationController _animationController;

  bool isAnimating = false;
  bool showTab = true;
  @override
  void initState() {
    retrieveItinerary(); //start the timer on loading
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  List steps = [];
  ValueNotifier<bool> isDialOpen = ValueNotifier(false);
  @override
  Widget build(BuildContext context) {
    bool hideTitleWhenExpanded = true;

    TabController tabController = TabController(length: 3, vsync: this);
    return SafeArea(
      child: Scaffold(
        floatingActionButton: isLoading == false
            ? Align(
                alignment: Alignment.bottomRight,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Align(
                      alignment: Alignment.bottomRight,
                      child: SizedBox(
                        height: 60,
                        width: 60,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const TripMapScreen(),
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Icon(
                              Icons.map_rounded,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: SizedBox(
                        height: 50,
                        child: SpeedDial(
                          shape: const CircleBorder(),
                          backgroundColor: Theme.of(context).primaryColor,
                          animationCurve: Curves.easeInOut,
                          overlayColor: Colors.black,
                          overlayOpacity: 0.4,
                          openCloseDial: isDialOpen,
                          children: [
                            SpeedDialChild(
                              shape: const CircleBorder(),
                              child: IconButton(
                                onPressed: () async {
                                  isDialOpen.value = false;
                                },
                                icon: Icon(
                                  Icons.airplane_ticket,
                                  color: Theme.of(context).primaryColor,
                                  size: 30,
                                ),
                              ),
                              label: 'Add Flight Ticket',
                            ),
                            SpeedDialChild(
                              shape: const CircleBorder(),
                              child: IconButton(
                                onPressed: () async {
                                  isDialOpen.value = false;
                                },
                                icon: Icon(
                                  Icons.local_activity,
                                  color: Theme.of(context).primaryColor,
                                  size: 30,
                                ),
                              ),
                              label: 'Add Ticket',
                            ),
                            // SpeedDialChild(
                            //   shape: const CircleBorder(),
                            //   child: IconButton(
                            //     onPressed: () async {
                            //       Navigator.push(
                            //         context,
                            //         MaterialPageRoute(
                            //           builder: (context) => NowPlaying(),
                            //         ),
                            //       );
                            //       isDialOpen.value = false;
                            //     },
                            //     icon: FaIcon(
                            //       FontAwesomeIcons.spotify,
                            //       color: Theme.of(context).primaryColor,
                            //       size: 30,
                            //     ),
                            //   ),
                            //   label: 'Add Spotify Playlist',
                            // ),
                          ],
                          label: Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : Container(),
        body: isLoading
            ? SizedBox(
                height: MediaQuery.of(context).size.height / 1.1,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      LoadingAnimationWidget.inkDrop(
                        color: Theme.of(context).primaryColor,
                        size: MediaQuery.of(context).size.height * 0.1,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Retrieving your itinerary...',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : NestedScrollView(
                scrollBehavior:
                    const MaterialScrollBehavior().copyWith(scrollbars: false),
                headerSliverBuilder: (BuildContext context, bool value) {
                  return <Widget>[
                    SliverPersistentHeader(
                      pinned: true,
                      floating: false,
                      delegate: CustomSliverDelegate(
                        expandedHeight: 180,
                        tabBar: TabBar(
                          labelStyle: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                          ),
                          labelPadding:
                              const EdgeInsets.only(left: 15, right: 15),
                          controller: tabController,
                          indicatorSize: TabBarIndicatorSize.label,
                          isScrollable: false,
                          labelColor: Theme.of(context).primaryColor,
                          unselectedLabelColor: Colors.grey[600],
                          indicator: CircleTabIndicator(
                            color: Theme.of(context).primaryColor,
                            radius: 4,
                          ),
                          tabs: const [
                            Tab(text: "Overview"),
                            Tab(text: "Itinerary"),
                            Tab(text: "Budget"),
                          ],
                        ),
                      ),
                    ),
                  ];
                },
                body: TabBarView(
                  controller: tabController,
                  children: [
                    OverviewTab(),
                    ItineraryTab(),
                    BudgetTab(),
                  ],
                ),
              ),
      ),
    );
  }
}

class CustomSliverDelegate extends SliverPersistentHeaderDelegate {
  final double expandedHeight;
  final bool hideTitleWhenExpanded;
  final TabBar tabBar;

  const CustomSliverDelegate({
    required this.expandedHeight,
    this.hideTitleWhenExpanded = true,
    required this.tabBar,
  });

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final appBarSize = expandedHeight - (shrinkOffset);
    final cardTopPosition = expandedHeight / 1.75 - shrinkOffset;
    final proportion = 2 - (expandedHeight / appBarSize);
    final percent = proportion < 0 || proportion > 1 ? 0.0 : proportion;

    return SizedBox(
      height: expandedHeight + expandedHeight / 2,
      child: Stack(
        children: [
          SizedBox(
            height: appBarSize < kToolbarHeight
                ? (kToolbarHeight * 1.7)
                : appBarSize,
            child: PreferredSize(
              preferredSize: Size.fromHeight(kToolbarHeight),
              child: AppBar(
                scrolledUnderElevation: 0,
                backgroundColor: Colors.white,
                flexibleSpace: appBarSize > kToolbarHeight
                    ? Image(
                        image: AssetImage('assets/images/sydney.jpg'),
                        fit: BoxFit.cover,
                        width: double.infinity,
                      )
                    : null,
                leading: IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: appBarSize > kToolbarHeight
                        ? Colors.white
                        : Colors.black,
                  ),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BottomNavBar(),
                      ),
                    );
                  },
                ),
                elevation: 0.0,
                title: Opacity(
                  opacity: hideTitleWhenExpanded ? 1.0 - percent : 1.0,
                  child: Text("Trip to Naivasha"),
                ),
                bottom: appBarSize < kToolbarHeight ? tabBar : null,
              ),
            ),
          ),
          Positioned(
            left: 0.0,
            right: 0.0,
            top: cardTopPosition > 0 ? cardTopPosition : 0,
            bottom: 0.0,
            child: Opacity(
              opacity: percent,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10 * percent),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.white.withOpacity(0.8),
                            Colors.white.withOpacity(0.5),
                          ],
                          begin: AlignmentDirectional.topStart,
                          end: AlignmentDirectional.bottomEnd,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        border: Border.all(
                          width: 1.5,
                          color: Colors.grey.withOpacity(0.5),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Trip to Naivasha",
                                  style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    showModalBottomSheet(
                                        context: context,
                                        builder: (context) {
                                          return Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              Center(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(
                                                    "Trip Settings",
                                                    style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              ListTile(
                                                leading: new Icon(Icons.delete),
                                                title: new Text('Delete trip'),
                                                onTap: () {
                                                  Navigator.pop(context);
                                                },
                                              ),
                                            ],
                                          );
                                        });
                                  },
                                  child: FaIcon(
                                    FontAwesomeIcons.ellipsis,
                                    color: Colors.grey[700],
                                    size: 30,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.calendar_today,
                                  color: Colors.grey[700],
                                ),
                                SizedBox(width: 10),
                                Text(
                                  "12th - 14th June 2021",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ElevatedButton(
                                  onPressed: () async {
                                    await Share.share(
                                        'check out our website https://fari-jcuo.onrender.com/');
                                  },
                                  child: Text(
                                    'Share Trip',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    primary: Theme.of(context).primaryColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    showModalBottomSheet(
                                        context: context,
                                        builder: (context) {
                                          return Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              Center(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(
                                                    "Trip Collaborators",
                                                    style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              ListTile(
                                                leading: new Icon(
                                                    Icons.person_add_alt),
                                                title: new Text(
                                                    'Invite trip mates',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    )),
                                                onTap: () {
                                                  Navigator.pop(context);
                                                },
                                              ),
                                              ListTile(
                                                leading: CircleAvatar(
                                                  radius: 16,
                                                  backgroundImage: AssetImage(
                                                    "assets/images/joseph-gonzalez-iFgRcqHznqg-unsplash.jpg",
                                                  ),
                                                ),
                                                title: Text(
                                                  'John Doe (You)',
                                                ),
                                              ),
                                            ],
                                          );
                                        });
                                  },
                                  child: CircleAvatar(
                                    radius: 18,
                                    backgroundImage: AssetImage(
                                      "assets/images/joseph-gonzalez-iFgRcqHznqg-unsplash.jpg",
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  double get maxExtent => expandedHeight + expandedHeight / 2;

  @override
  double get minExtent => kToolbarHeight + 50;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
