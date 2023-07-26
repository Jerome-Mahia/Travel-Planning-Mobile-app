import 'dart:io';

import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:travel_planner_app_cs_project/data/data.dart';
import 'package:travel_planner_app_cs_project/main.dart';
import 'package:travel_planner_app_cs_project/models/delete_itinerary.dart';
import 'package:travel_planner_app_cs_project/models/destination.dart';
import 'package:http/http.dart' as http;
import 'package:travel_planner_app_cs_project/models/fetch_all_itineraries.dart';
import 'package:travel_planner_app_cs_project/models/get_user_details.dart';
import 'package:travel_planner_app_cs_project/screens/planning/trip_detail_screen.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:travel_planner_app_cs_project/screens/spotify/now_playing_screen.dart';

class SavedPlanScreen extends ConsumerStatefulWidget {
  const SavedPlanScreen({super.key});

  @override
  _SavedPlanScreenState createState() => _SavedPlanScreenState();
}

class _SavedPlanScreenState extends ConsumerState<SavedPlanScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Center(child: Text('Saved Trips')),
        ),
        body: FutureBuilder<List<Itinerary>>(
          future: getEveryItinerary(context),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                  child:
                      CircularProgressIndicator()); // Show a loading indicator while data is being fetched
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.data!.isEmpty) {
              print(snapshot.data!.length);
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/images/empty_plans_svg.svg',
                      height: MediaQuery.of(context).size.height * 0.3,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      'No Saved Trips',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              );
            } else if (snapshot.hasData) {
              final itineraries = snapshot.data!;

              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Created by you',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: itineraries.length,
                          itemBuilder: (context, index) {
                            Itinerary itinerary = itineraries[index];
                            DateTime firstday = (itinerary.startDate);
                            String firstDate =
                                DateFormat.MMMd().format(firstday);
                            DateTime lastday = (itinerary.endDate);
                            String lastDate = DateFormat.MMMd().format(lastday);
                            return Padding(
                              padding:
                                  const EdgeInsets.only(top: 5.0, bottom: 5.0),
                              child: GestureDetector(
                                onTap: () {
                                  showModalBottomSheet(
                                      context: context,
                                      builder: (context) {
                                        return Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            ListTile(
                                              leading: new Icon(Icons.info),
                                              title:
                                                  new Text('View Trip Details'),
                                              onTap: () {
                                                PersistentNavBarNavigator
                                                    .pushNewScreen(
                                                  context,
                                                  screen: TripDetailScreen(
                                                    id: itinerary.id,
                                                  ),
                                                  withNavBar:
                                                      false, // OPTIONAL VALUE. True by default.
                                                  pageTransitionAnimation:
                                                      PageTransitionAnimation
                                                          .cupertino,
                                                );
                                              },
                                            ),
                                            ListTile(
                                              leading: new FaIcon(
                                                  FontAwesomeIcons.spotify),
                                              title: new Text('Play Spotify'),
                                              onTap: () {
                                                PersistentNavBarNavigator
                                                    .pushNewScreen(
                                                  context,
                                                  screen: NowPlaying(),
                                                  withNavBar:
                                                      false, // OPTIONAL VALUE. True by default.
                                                  pageTransitionAnimation:
                                                      PageTransitionAnimation
                                                          .slideUp,
                                                );
                                              },
                                            ),
                                            ListTile(
                                              leading: new Icon(Icons.share),
                                              title: new Text('Share'),
                                              onTap: () async {
                                                
                                                Share.share('Check out this amazing trip to ${itinerary.title} on Fari Travel Planner App!');
                                              },
                                            ),
                                            ListTile(
                                              leading: new Icon(
                                                Icons.delete,
                                                color: Colors.red,
                                              ),
                                              title: new Text(
                                                'Delete Trip',
                                                style: TextStyle(
                                                    color: Colors.red),
                                              ),
                                              onTap: () {
                                                deleteItinerary(context,
                                                    itinerary.id.toString());
                                                setState(() {});
                                              },
                                            ),
                                          ],
                                        );
                                      });
                                },
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    ConstrainedBox(
                                      constraints: BoxConstraints(
                                        maxWidth:
                                            MediaQuery.of(context).size.width *
                                                0.28,
                                        maxHeight:
                                            MediaQuery.of(context).size.width *
                                                0.28,
                                      ),
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                        child: Image.asset(
                                          'assets/images/naivasha.jpg',
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              10, 10, 0, 0),
                                          child: Text(
                                            '${itinerary.title}',
                                            style: TextStyle(
                                              fontSize: 20.0,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.5,
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                5, 10, 0, 0),
                                            child: Row(
                                              children: [
                                                Wrap(
                                                  children: [
                                                    Container(
                                                  height: 30,
                                                  width: 30,
                                                  child: ClipOval(
                                                    child: FancyShimmerImage(
                                                      imageUrl:
                                                          'https://res.cloudinary.com/dgcbtjq3c/${ref.watch(userimageProvider)}',
                                                      boxFit: BoxFit.cover,
                                                      shimmerBaseColor:
                                                          Colors.grey[300],
                                                      shimmerHighlightColor:
                                                          Colors.grey[100],
                                                    ),
                                                  ),
                                                ),
                                                    SizedBox(
                                                      width: 5,
                                                    ),
                                                    Text(
                                                      '${firstDate} - ${lastDate}',
                                                      style: TextStyle(
                                                        fontSize: 18.0,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Colors.grey[700],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Created with friends',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return Text('Something went wrong :(');
            }
          },
        ),
      ),
    );
  }
}
