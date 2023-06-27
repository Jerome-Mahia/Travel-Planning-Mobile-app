import 'dart:async';

import 'package:flutter/material.dart';
import 'package:image_pixels/image_pixels.dart';
import 'package:travel_planner_app_cs_project/models/destination.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:travel_planner_app_cs_project/screens/planning/planning_form_screen.dart';
import 'package:travel_planner_app_cs_project/screens/search/search_destination_screen.dart';

class DestinationScreen extends StatefulWidget {
  final Destination destination;
  const DestinationScreen({Key? key, required this.destination})
      : super(key: key);

  @override
  State<DestinationScreen> createState() => _DestinationScreenState();
}

class _DestinationScreenState extends State<DestinationScreen>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    TabController tabController = TabController(length: 3, vsync: this);
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.35,
                    width: MediaQuery.of(context).size.width,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                    ),
                    child: Hero(
                      tag: widget.destination.mainImageUrl,
                      child: ImagePixels(
                          imageProvider:
                              AssetImage(widget.destination.detailsImageUrl),
                          builder: (context, img) {
                            return Image(
                              image: AssetImage(
                                  widget.destination.detailsImageUrl),
                              height: MediaQuery.of(context).size.height * 0.4,
                              width: MediaQuery.of(context).size.width,
                              fit: BoxFit.cover,
                            );
                          }),
                      // child: Image(
                      //   image: AssetImage(widget.destination.detailsImageUrl),
                      //   height: MediaQuery.of(context).size.height * 0.4,
                      //   width: MediaQuery.of(context).size.width,
                      //   fit: BoxFit.cover,
                      // ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15.0,
                      vertical: 15.0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: Colors.blueGrey.withOpacity(0.2),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Icon(
                                  Icons.arrow_back_ios,
                                  color: Colors.white,
                                  size: 25.0,
                                ),
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: Colors.blueGrey.withOpacity(0.1),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Icon(
                                Icons.favorite,
                                color: Theme.of(context).primaryColor,
                                size: 30.0,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 15.0,
                      right: 15,
                      top: 15,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              widget.destination.title,
                              style: const TextStyle(
                                fontSize: 32.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '\$\$\$',
                              style: TextStyle(
                                fontSize: 32.0,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor,
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 15.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Wrap(
                                children: [
                                  const Icon(
                                    Icons.star,
                                    color: Color.fromARGB(255, 254, 229, 0),
                                    size: 25,
                                  ),
                                  Text('${widget.destination.rating} (2.7K)'),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        child: Align(
                          alignment: Alignment.center,
                          child: TabBar(
                            labelPadding:
                                const EdgeInsets.only(left: 15, right: 15),
                            indicatorSize: TabBarIndicatorSize.label,
                            isScrollable: true,
                            controller: tabController,
                            labelColor: Theme.of(context).primaryColor,
                            unselectedLabelColor: Colors.grey,
                            indicator: CircleTabIndicator(
                                color: Theme.of(context).primaryColor,
                                radius: 4),
                            tabs: const [
                              Tab(text: "Overview"),
                              Tab(text: "Discover"),
                              Tab(text: "Reviews"),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 15.0, right: 15, bottom: 15),
                    child: Text(
                      widget.destination.description,
                      style: const TextStyle(
                        color: Color.fromRGBO(165, 167, 172, 1),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0, right: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Wrap(
                          children: [
                            const Icon(
                              Icons.access_time_rounded,
                              color: Colors.blue,
                              size: 20,
                            ),
                            Text(
                              widget.destination.duration,
                              style: const TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                        Wrap(
                          children: [
                            Icon(
                              Icons.location_pin,
                              color: Theme.of(context).primaryColor,
                              size: 20,
                            ),
                            Text(
                              widget.destination.distance,
                              style: const TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                        Wrap(
                          children: [
                            const Icon(
                              Icons.sunny,
                              color: Colors.orangeAccent,
                              size: 20,
                            ),
                            Text(
                              widget.destination.temperature,
                              style: const TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 65),
                    child: Row(
                      children: const [
                        Text(
                          'Duration',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            letterSpacing: 0.8,
                            color: Color.fromRGBO(165, 167, 172, 1),
                          ),
                        ),
                        SizedBox(
                          width: 60,
                        ),
                        Text(
                          'Distance',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            letterSpacing: 0.8,
                            color: Color.fromRGBO(165, 167, 172, 1),
                          ),
                        ),
                        SizedBox(
                          width: 50,
                        ),
                        Text(
                          'Sunny',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            letterSpacing: 0.8,
                            color: Color.fromRGBO(165, 167, 172, 1),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Center(
                          child: InkWell(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => SearchDestinationScreen(),
                              ),
                            ),
                            child: Container(
                              //width: 100.0,
                              height: 55.0,
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                border: Border.all(
                                  color: Theme.of(context).primaryColor,
                                ),
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              child: const Center(
                                child: Text(
                                  'Start Planning',
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// implementing a class that gives the dots color or painty
class CircleTabIndicator extends Decoration {
  final Color color;
  double radius;
  CircleTabIndicator({required this.color, required this.radius});

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    // TODO: implement createBoxPainter

    return _CirclePainter(color: color, radius: radius);
  }
}

class _CirclePainter extends BoxPainter {
  final Color color;
  double radius;
  _CirclePainter({required this.color, required this.radius});

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    Paint paint = Paint();
    paint.color = color;
    paint.isAntiAlias = true;
    // putting the circle middle and on bottom
    final Offset circleOffset = Offset(
        configuration.size!.width / 2 - radius / 2,
        configuration.size!.height - radius);
    // TODO: implement paint
    canvas.drawCircle(offset + circleOffset, radius, paint);
  }
}
