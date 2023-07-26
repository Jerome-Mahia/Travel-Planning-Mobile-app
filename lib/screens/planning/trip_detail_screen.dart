import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:travel_planner_app_cs_project/main.dart';
import 'package:travel_planner_app_cs_project/data/step_guide.dart';
import 'package:travel_planner_app_cs_project/models/delete_itinerary.dart';
import 'package:travel_planner_app_cs_project/models/fetch_itinerary_details.dart';
import 'package:travel_planner_app_cs_project/models/login.dart';
import 'package:travel_planner_app_cs_project/models/search_friends.dart';
import 'package:travel_planner_app_cs_project/screens/home/feed_screen.dart';
import 'package:travel_planner_app_cs_project/screens/map/trip_map_screen.dart';
import 'package:travel_planner_app_cs_project/screens/planning/budget_screen.dart';
import 'package:travel_planner_app_cs_project/screens/planning/itinerary_screen.dart';
import 'package:travel_planner_app_cs_project/screens/planning/overview_screen.dart';
import 'package:travel_planner_app_cs_project/widgets/bottom_navbar_widget.dart';
import 'package:http/http.dart' as http;

class TripDetailScreen extends ConsumerStatefulWidget {
  const TripDetailScreen({super.key, required this.id});
  final int id;

  @override
  _TripDetailScreenState createState() => _TripDetailScreenState();
}

class _TripDetailScreenState extends ConsumerState<TripDetailScreen>
    with TickerProviderStateMixin {
  // bool isLoading = true;
  // void retrieveItinerary() {
  //   // if(getItineraryDetails(context) == null){
  //   //   setState(() {
  //   //     isLoading = true;
  //   //   });
  //   // }
  //   // else{
  //   //   setState(() {
  //   //     isLoading = false;
  //   //   });
  //   // }
  //   Timer.periodic(const Duration(seconds: 5), (t) {
  //     setState(() {
  //       isLoading = false; //set loading to false
  //     });
  //     t.cancel(); //stops the timer
  //   });
  // }

  late AnimationController _animationController;

  bool isAnimating = false;
  bool showTab = true;
  @override
  void initState() {
    // retrieveItinerary(); //start the timer on loading
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

  int identification = 0;
  List steps = [];
  ValueNotifier<bool> isDialOpen = ValueNotifier(false);
  @override
  Widget build(BuildContext context) {
    bool hideTitleWhenExpanded = true;

    TabController tabController = TabController(length: 3, vsync: this);
    return SafeArea(
      child: FutureBuilder<FetchItineraryDetails>(
          future: getItineraryDetails(context, widget.id.toString()),
          builder: (context, snapshot) {
            FetchItineraryDetails? details = snapshot.data;
            Itinerary itinerary = details!.itinerary;
            List<dynamic> collaborators = details.collaborators;
            List<Day> days = details.days;

            String title = itinerary.title;
            int budget = itinerary.budget;

            String formattedStartDate =
                DateFormat.MMMd().format(itinerary.starDate);
            String formattedEndDate =
                DateFormat.yMMMd().format(itinerary.endDate);

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Scaffold(
                body: SizedBox(
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
                ),
              );
            } else if (snapshot.hasData) {
              return Scaffold(
                floatingActionButton: Align(
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
                                  builder: (context) => TripMapScreen(
                                    tripDays: days,
                                  ),
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
                      // SizedBox(height: 16),
                      // Align(
                      //   alignment: Alignment.bottomRight,
                      //   child: SizedBox(
                      //     height: 50,
                      //     child: SpeedDial(
                      //       shape: const CircleBorder(),
                      //       backgroundColor: Theme.of(context).primaryColor,
                      //       animationCurve: Curves.easeInOut,
                      //       overlayColor: Colors.black,
                      //       overlayOpacity: 0.4,
                      //       openCloseDial: isDialOpen,
                      //       children: [
                      //         // SpeedDialChild(
                      //         //   shape: const CircleBorder(),
                      //         //   child: IconButton(
                      //         //     onPressed: () async {
                      //         //       isDialOpen.value = false;
                      //         //     },
                      //         //     icon: Icon(
                      //         //       Icons.airplane_ticket,
                      //         //       color: Theme.of(context).primaryColor,
                      //         //       size: 30,
                      //         //     ),
                      //         //   ),
                      //         //   label: 'Add Flight Ticket',
                      //         // ),
                      //         // SpeedDialChild(
                      //         //   shape: const CircleBorder(),
                      //         //   child: IconButton(
                      //         //     onPressed: () async {
                      //         //       isDialOpen.value = false;
                      //         //     },
                      //         //     icon: Icon(
                      //         //       Icons.local_activity,
                      //         //       color: Theme.of(context).primaryColor,
                      //         //       size: 30,
                      //         //     ),
                      //         //   ),
                      //         //   label: 'Add Ticket',
                      //         // ),
                      //         // SpeedDialChild(
                      //         //   shape: const CircleBorder(),
                      //         //   child: IconButton(
                      //         //     onPressed: () async {
                      //         //       Navigator.push(
                      //         //         context,
                      //         //         MaterialPageRoute(
                      //         //           builder: (context) => NowPlaying(),
                      //         //         ),
                      //         //       );
                      //         //       isDialOpen.value = false;
                      //         //     },
                      //         //     icon: FaIcon(
                      //         //       FontAwesomeIcons.spotify,
                      //         //       color: Theme.of(context).primaryColor,
                      //         //       size: 30,
                      //         //     ),
                      //         //   ),
                      //         //   label: 'Add Spotify Playlist',
                      //         // ),
                      //       ],
                      //       label: Icon(
                      //         Icons.add,
                      //         color: Colors.white,
                      //         size: 30,
                      //       ),
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ),
                body: NestedScrollView(
                  scrollBehavior: const MaterialScrollBehavior()
                      .copyWith(scrollbars: false),
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
                            tabController: tabController,
                            title: title,
                            startDate: formattedStartDate,
                            endDate: formattedEndDate,
                            image: ref.watch(userimageProvider),
                            id: itinerary.id.toString(),
                            name: ref.watch(usernameProvider),
                            page: InviteFriendsWidget(
                                tripId: itinerary.id.toString())),
                      ),
                    ];
                  },
                  body: TabBarView(
                    controller: tabController,
                    children: [
                      OverviewTab(
                        tripDays: days,
                      ),
                      ItineraryTab(
                        tripDays: days,
                        id: itinerary.id.toString(),
                      ),
                      BudgetTab(
                        tripDays: days,
                        budget: budget,
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }
}

class InviteFriendsWidget extends StatefulWidget {
  const InviteFriendsWidget({
    Key? key,
    required this.tripId,
  }) : super(key: key);
  final String? tripId;

  @override
  State<InviteFriendsWidget> createState() => _InviteFriendsWidgetState();
}

class _InviteFriendsWidgetState extends State<InviteFriendsWidget> {
  @override
  Widget build(BuildContext context) {
    final TextEditingController friendUserNameController =
        TextEditingController();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          Text(
            "Invite Friends",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            "Invite your friends to join this trip",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            constraints: const BoxConstraints(maxWidth: double.infinity),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: TextField(
                    controller: friendUserNameController,
                    keyboardType: TextInputType.text,
                    onSubmitted: (value) {},
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search),
                      prefixIconColor: Colors.grey[800],
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 15.0,
                        horizontal: 20,
                      ),
                      fillColor: Colors.grey[200],
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide: const BorderSide(width: 0.8),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide: const BorderSide(
                          width: 0.8,
                          color: Color.fromRGBO(255, 238, 238, 1),
                        ),
                      ),
                      hintText: 'Enter friends username',
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                InkWell(
                  onTap: () {},
                  child: Container(
                    width: 80.0,
                    height: 40.0,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      border: Border.all(
                        color: Theme.of(context).primaryColor,
                      ),
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Center(
                        child: Text(
                          'Search',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // const SizedBox(height: 16),
          // Container(
          //   height: 50,
          //   decoration: BoxDecoration(
          //     color: Theme.of(context).primaryColor,
          //     borderRadius: BorderRadius.circular(30),
          //   ),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     children: [
          //       const Icon(
          //         Icons.person_add,
          //         color: Colors.white,
          //         size: 30,
          //       ),
          //       const SizedBox(width: 10),
          //       const Text(
          //         "Invite Friends",
          //         style: TextStyle(
          //           fontSize: 15,
          //           fontWeight: FontWeight.w400,
          //           color: Colors.white,
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          const SizedBox(height: 16),
          const Text(
            "Invite Friends",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          FutureBuilder<List<User>>(
              future: searchFriends(context, friendUserNameController.text),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                      child:
                          CircularProgressIndicator()); // Show a loading indicator while data is being fetched
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (snapshot.data!.isEmpty) {
                } else if (snapshot.hasData) {
                  final friends = snapshot.data;
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: friends!.length,
                    itemBuilder: (context, index) {
                      User friend = friends[index];
                      return Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          title: Text(
                            friend.name,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          subtitle: Text(
                            friend.email,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          trailing: Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: IconButton(
                              onPressed: () async {
                                addCollaborator(BuildContext context,
                                    String tripId, int friendId) async {
                                  try {
                                    final Accesstoken = await retrieveToken();
                                    final response = await http.post(
                                      Uri.parse(
                                          "https://fari-jcuo.onrender.com/main/add-remove-collaborator/$tripId"),
                                      headers: <String, String>{
                                        'Content-Type':
                                            'application/json; charset=UTF-8',
                                        'Authorization':
                                            'Bearer ${Accesstoken.toString()}',
                                      },
                                      body: jsonEncode(<String, dynamic>{
                                        'collaborator': friendId,
                                        'action': 'add'
                                      }),
                                    );

                                    if (response.statusCode == 200) {
                                      Navigator.pop(context);
                                      return SnackBar(
                                          content: Text(
                                              'Successfully added collaborator'));
                                    } else {
                                      return SnackBar(
                                          content: Text(
                                              'Unable to add collaborator'));
                                    }
                                  } catch (e) {
                                    print(e.toString());
                                    throw Exception(
                                        'Failed to add collaborator: ${e.toString()}');
                                  }
                                }

                                setState(() {
                                  addCollaborator(context,
                                      widget.tripId.toString(), friend.id);
                                  collaborator_list.add(
                                    User(
                                      id: friend.id,
                                      name: friend.name,
                                      email: friend.email,
                                      phone: friend.phone,
                                    ),
                                  );
                                });
                              },
                              icon: Icon(
                                Icons.person_add,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
                return Center(
                  child: const Text(
                    "You have not invited any friends yet",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                );
              }),
        ],
      ),
    );
  }
}

class CustomSliverDelegate extends SliverPersistentHeaderDelegate {
  final double expandedHeight;
  final bool hideTitleWhenExpanded;
  final TabBar tabBar;
  final TabController tabController;
  final String? title;
  final String? startDate;
  final String? endDate;
  final String? image;
  final String? id;
  final String? name;
  final Widget page;

  const CustomSliverDelegate({
    required this.expandedHeight,
    this.hideTitleWhenExpanded = true,
    required this.tabBar,
    required this.tabController,
    required this.title,
    required this.startDate,
    required this.endDate,
    required this.image,
    required this.id,
    required this.name,
    required this.page,
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
                        image: AssetImage('assets/images/naivasha.jpg'),
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
                  child: Text("$title"),
                ),
                bottom: appBarSize < kToolbarHeight
                    ? TabBar(
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
                      )
                    : null,
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
                                  "$title",
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
                                                leading: new Icon(
                                                  Icons.delete,
                                                  color: Colors.red,
                                                ),
                                                title: new Text(
                                                  'Delete trip',
                                                  style: TextStyle(
                                                      color: Colors.red),
                                                ),
                                                onTap: () {
                                                  showDialog(
                                                      context: context,
                                                      builder: (context) {
                                                        return AlertDialog(
                                                          title: Text(
                                                              'Delete Trip'),
                                                          content: Text(
                                                              'Are you sure you want to delete this trip?'),
                                                          actions: <Widget>[
                                                            TextButton(
                                                              onPressed: () {
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              child: Text(
                                                                  'Cancel'),
                                                            ),
                                                            TextButton(
                                                              onPressed: () {
                                                                deleteItinerary(
                                                                    context,
                                                                    id.toString());
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              child: Text(
                                                                  'Delete'),
                                                            ),
                                                          ],
                                                        );
                                                      });
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
                                  "${startDate} - ${endDate}",
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
                                    String url =
                                        'https://res.cloudinary.com/dgcbtjq3c/${image}';
                                    http.Response response = await http.get(
                                      Uri.parse(url),
                                    );
                                    final directory =
                                        await getTemporaryDirectory();
                                    final path = directory.path;
                                    final file = File('$path/image.png');
                                    file.writeAsBytes(response.bodyBytes);
                                    await Share.shareFiles(['$path/image.png'],
                                        text:
                                            'Check out this amazing ${title} on Fari Travel Planner App!');
                                    // await Share.share(
                                    //     'check out our website https://fari-jcuo.onrender.com/');
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
                                                  showModalBottomSheet(
                                                      context: context,
                                                      builder: (context) =>
                                                          page);
                                                },
                                              ),
                                              ListView.builder(
                                                itemCount:
                                                    collaborator_list.length,
                                                shrinkWrap: true,
                                                itemBuilder: (context, index) {
                                                  User user =
                                                      collaborator_list[index];
                                                  return Column(
                                                    children: [
                                                      Divider(),
                                                      ListTile(
                                                        leading: Container(
                                                          height: 35,
                                                          width: 35,
                                                          child: ClipOval(
                                                            child:
                                                                FancyShimmerImage(
                                                              imageUrl:
                                                                  'https://res.cloudinary.com/dgcbtjq3c/${image}',
                                                              boxFit:
                                                                  BoxFit.cover,
                                                              shimmerBaseColor:
                                                                  Colors.grey[
                                                                      300],
                                                              shimmerHighlightColor:
                                                                  Colors.grey[
                                                                      100],
                                                            ),
                                                          ),
                                                        ),
                                                        title: Text(
                                                          '${user.name}',
                                                          style: TextStyle(
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                        trailing: Container(
                                                          width: 40,
                                                          height: 40,
                                                          decoration:
                                                              BoxDecoration(
                                                                  shape: BoxShape
                                                                      .circle,
                                                                  color: Colors
                                                                      .red),
                                                          child: Center(
                                                            child: IconButton(
                                                              icon: Icon(
                                                                Icons.delete,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                              onPressed: () {
                                                                showDialog(
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (context) {
                                                                      return AlertDialog(
                                                                        title: Text(
                                                                            'Remove Collaborator'),
                                                                        content:
                                                                            Text('Are you sure you want to remove this collaborator?'),
                                                                        actions: <Widget>[
                                                                          TextButton(
                                                                            onPressed:
                                                                                () {
                                                                              Navigator.pop(context);
                                                                            },
                                                                            child:
                                                                                Text('Cancel'),
                                                                          ),
                                                                          TextButton(
                                                                            onPressed:
                                                                                () {
                                                                              removeCollaborator(BuildContext context, String tripId, int friendId) async {
                                                                                try {
                                                                                  final Accesstoken = await retrieveToken();
                                                                                  final response = await http.post(
                                                                                    Uri.parse("https://fari-jcuo.onrender.com/main/add-remove-collaborator/$tripId"),
                                                                                    headers: <String, String>{
                                                                                      'Content-Type': 'application/json; charset=UTF-8',
                                                                                      'Authorization': 'Bearer ${Accesstoken.toString()}',
                                                                                    },
                                                                                    body: jsonEncode(<String, dynamic>{
                                                                                      'collaborator': friendId,
                                                                                      'action': 'remove'
                                                                                    }),
                                                                                  );

                                                                                  if (response.statusCode == 200) {
                                                                                    Navigator.pop(context);
                                                                                    return SnackBar(content: Text('Successfully added collaborator'));
                                                                                  } else {
                                                                                    return SnackBar(content: Text('Unable to add collaborator'));
                                                                                  }
                                                                                } catch (e) {
                                                                                  print(e.toString());
                                                                                  throw Exception('Failed to add collaborator: ${e.toString()}');
                                                                                }
                                                                              }

                                                                              removeCollaborator(context, id.toString(), user.id);
                                                                              collaborator_list.removeAt(index);
                                                                              Navigator.pop(context);
                                                                            },
                                                                            child:
                                                                                Text('Remove', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                                                                          ),
                                                                        ],
                                                                      );
                                                                    });
                                                              },
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              ),
                                              ListTile(
                                                leading: Container(
                                                  height: 35,
                                                  width: 35,
                                                  child: ClipOval(
                                                    child: FancyShimmerImage(
                                                      imageUrl:
                                                          'https://res.cloudinary.com/dgcbtjq3c/${image}',
                                                      boxFit: BoxFit.cover,
                                                      shimmerBaseColor:
                                                          Colors.grey[300],
                                                      shimmerHighlightColor:
                                                          Colors.grey[100],
                                                    ),
                                                  ),
                                                ),
                                                title: Text(
                                                  '${name} (You)',
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          );
                                        });
                                  },
                                  child: Container(
                                    height: 40,
                                    width: 40,
                                    child: ClipOval(
                                      child: FancyShimmerImage(
                                        imageUrl:
                                            'https://res.cloudinary.com/dgcbtjq3c/${image}',
                                        boxFit: BoxFit.cover,
                                        shimmerBaseColor: Colors.grey[300],
                                        shimmerHighlightColor: Colors.grey[100],
                                      ),
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
