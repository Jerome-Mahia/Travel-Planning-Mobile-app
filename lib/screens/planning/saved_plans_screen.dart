import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:travel_planner_app_cs_project/data/data.dart';
import 'package:travel_planner_app_cs_project/models/destination.dart';
import 'package:http/http.dart' as http;
import 'package:travel_planner_app_cs_project/screens/planning/trip_detail_screen.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:travel_planner_app_cs_project/screens/spotify/now_playing_screen.dart';

class SavedPlanScreen extends StatefulWidget {
  const SavedPlanScreen({super.key});

  @override
  State<SavedPlanScreen> createState() => _SavedPlanScreenState();
}

class _SavedPlanScreenState extends State<SavedPlanScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Center(child: Text('Saved Trips')),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: all_destinations.length,
                    itemBuilder: (context, index) {
                      Destination trip = all_destinations[index];
                      return Padding(
                        padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
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
                                        title: new Text('View Trip Details'),
                                        onTap: () {
                                          PersistentNavBarNavigator
                                              .pushNewScreen(
                                            context,
                                            screen: TripDetailScreen(),
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
                                          Navigator.push(context, 
                                          MaterialPageRoute(builder: (context) => NowPlaying()));
                                        },
                                      ),
                                      ListTile(
                                        leading: new Icon(Icons.share),
                                        title: new Text('Share'),
                                        onTap: () async {
                                          // final box = context.findRenderObject()
                                          //     as RenderBox?;

                                          // var asset =
                                          //     "assets/images/${trip.shareImageUrl}";

                                          // ByteData imagebyte =
                                          //     await rootBundle.load(asset);
                                          // final temp =
                                          //     await getTemporaryDirectory();
                                          // final path =
                                          //     '${temp.path}/temp_image_name.png';
                                          // File(path).writeAsBytesSync(
                                          //     imagebyte.buffer.asUint8List());
                                          // await Share.shareXFiles([
                                          //   XFile(path, mimeType: 'image/jpg'),
                                          // ],
                                          //     sharePositionOrigin: box!
                                          //             .localToGlobal(
                                          //                 Offset.zero) &
                                          //         box.size,
                                          //     text:
                                          //         'Check out this amazing trip to ${trip.title} on Fari Travel Planner App!');
                                          final String imageAssets =
                                              trip.detailsImageUrl;
                                          Image.asset(imageAssets);
                                          final ByteData data = await rootBundle
                                              .load(imageAssets);
                                          final buffer = data.buffer;
                                          Share.shareFiles([imageAssets],
                                              subject:
                                                  'Check out this amazing trip to ${trip.title} on Fari Travel Planner App!');
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
                                      MediaQuery.of(context).size.width * 0.28,
                                  maxHeight:
                                      MediaQuery.of(context).size.width * 0.28,
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15.0),
                                  child: Image.asset(
                                    trip.mainImageUrl,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(10, 10, 0, 0),
                                    child: Text(
                                      'Trip to ${trip.title}',
                                      style: TextStyle(
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.5,
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          5, 10, 0, 0),
                                      child: Row(
                                        children: [
                                          Wrap(
                                            children: [
                                              CircleAvatar(
                                                radius: 15,
                                                backgroundImage: AssetImage(
                                                  "assets/images/joseph-gonzalez-iFgRcqHznqg-unsplash.jpg",
                                                ),
                                              ),
                                              SizedBox(
                                                width: 3,
                                              ),
                                              Text(
                                                'Apr 3 - 8',
                                                style: TextStyle(
                                                  fontSize: 18.0,
                                                  fontWeight: FontWeight.w500,
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
