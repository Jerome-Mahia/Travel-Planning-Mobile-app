import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:ui' as ui;

import 'package:travel_planner_app_cs_project/constants/constants.dart';
import 'package:travel_planner_app_cs_project/data/map.dart';

class TripMapScreen extends StatefulWidget {
  const TripMapScreen({super.key});

  @override
  State<TripMapScreen> createState() => _TripMapScreenState();
}

class _TripMapScreenState extends State<TripMapScreen>
    with TickerProviderStateMixin {
  final pageController = PageController();
  int selectedIndex = 0;
  var currentLocation = AppConstants.myLocation;

  late final MapController mapController;

  @override
  void initState() {
    super.initState();
    mapController = MapController();
  }

  final formatter = NumberFormat.decimalPattern();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text(
            'Map View',
          ),
          centerTitle: true,
          elevation: 0,
        ),
        body: Stack(
          children: [
            FlutterMap(
              mapController: mapController,
              options: MapOptions(
                minZoom: 5,
                maxZoom: 18,
                zoom: 12,
                center: mapMarkers[0].location,
              ),
              children: [
                TileLayer(
                  urlTemplate: AppConstants.mapBoxUrl,
                  additionalOptions: const {
                    'mapStyleId': AppConstants.mapBoxStyleId,
                    'accessToken': AppConstants.mapBoxAccessToken,
                  },
                ),
                MarkerLayer(
                  markers: [
                    for (int i = 0; i < mapMarkers.length; i++)
                      Marker(
                        height: 60,
                        width: 60,
                        point:
                            mapMarkers[i].location ?? AppConstants.myLocation,
                        builder: (_) {
                          return GestureDetector(
                            onTap: () {
                              pageController.animateToPage(
                                i,
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.easeInOut,
                              );
                              selectedIndex = i;
                              currentLocation = mapMarkers[i].location ??
                                  AppConstants.myLocation;
                              _animatedMapMove(currentLocation, 11.5);
                              setState(() {});
                            },
                            child: AnimatedScale(
                              duration: const Duration(milliseconds: 500),
                              scale: selectedIndex == i ? 1 : 0.7,
                              child: AnimatedOpacity(
                                duration: const Duration(milliseconds: 500),
                                opacity: selectedIndex == i ? 1 : 0.5,
                                child: SvgPicture.asset(
                                  'assets/icons/map_marker.svg',
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                  ],
                ),
              ],
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              height: MediaQuery.of(context).size.height * 0.18,
              child: PageView.builder(
                controller: pageController,
                onPageChanged: (value) {
                  selectedIndex = value;
                  currentLocation =
                      mapMarkers[value].location ?? AppConstants.myLocation;
                  _animatedMapMove(currentLocation, 11.5);
                  setState(() {});
                },
                itemCount: mapMarkers.length,
                itemBuilder: (_, index) {
                  MapMarker locationInterests = mapMarkers[index];
                  return Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 5,
                                  color: Colors.grey.withOpacity(0.5),
                                  offset: const Offset(0.0, 1),
                                ),
                              ],
                            ),
                            height: MediaQuery.of(context).size.height * 0.14,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Wrap(
                                        children: [
                                          Icon(
                                            Icons.location_on,
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                          SizedBox(width: 5),
                                          Text(
                                            locationInterests.title,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                              color: Color.fromARGB(
                                                  255, 44, 38, 38),
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          showDialog(
                                            useRootNavigator: false,
                                            context: context,
                                            builder: (context) {
                                              return Dialog(
                                                child: ListView(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                    vertical: 11,
                                                  ),
                                                  shrinkWrap: true,
                                                  children: [
                                                    'Delete',
                                                  ]
                                                      .map(
                                                        (e) => InkWell(
                                                          child: Container(
                                                            padding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                              vertical: 12,
                                                              horizontal: 16,
                                                            ),
                                                            child: Text(
                                                              e,
                                                              style: TextStyle(
                                                                  fontSize: 20,
                                                                  color: Colors
                                                                      .red[700],
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                          ),
                                                          onTap: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                        ),
                                                      )
                                                      .toList(),
                                                ),
                                              );
                                            },
                                          );
                                        },
                                        child: FaIcon(
                                          FontAwesomeIcons.ellipsis,
                                          color: Colors.grey[700],
                                          size: 25,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Divider(
                                    color: Colors.grey[400],
                                    thickness: 1,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Icon(
                                        Icons.access_time,
                                        color: Colors.black54,
                                      ),
                                      SizedBox(width: 5),
                                      Wrap(
                                        children: [
                                          Text(
                                            'Afternoon',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                              color: Colors.black54,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Icon(
                                        Icons.bookmark,
                                        color: Colors.black54,
                                      ),
                                      SizedBox(width: 5),
                                      Wrap(
                                        children: [
                                          Text(
                                            'Added for',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                              color: Colors.black54,
                                            ),
                                          ),
                                          Text(
                                            locationInterests.date,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                              color: Theme.of(context)
                                                  .primaryColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          onTap: () {},
                        ),
                      ],
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  void _animatedMapMove(LatLng destLocation, double destZoom) {
    // Create some tweens. These serve to split up the transition from one location to another.
    // In our case, we want to split the transition be<tween> our current map center and the destination.
    final latTween = Tween<double>(
        begin: mapController.center.latitude, end: destLocation.latitude);
    final lngTween = Tween<double>(
        begin: mapController.center.longitude, end: destLocation.longitude);
    final zoomTween = Tween<double>(begin: mapController.zoom, end: destZoom);

    // Create a animation controller that has a duration and a TickerProvider.
    var controller = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    // The animation determines what path the animation will take. You can try different Curves values, although I found
    // fastOutSlowIn to be my favorite.
    Animation<double> animation =
        CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn);

    controller.addListener(() {
      mapController.move(
        LatLng(latTween.evaluate(animation), lngTween.evaluate(animation)),
        zoomTween.evaluate(animation),
      );
    });

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.dispose();
      } else if (status == AnimationStatus.dismissed) {
        controller.dispose();
      }
    });

    controller.forward();
  }
}
