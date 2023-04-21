import 'dart:async';

import 'package:flutter/material.dart';
import 'package:travel_planner_app_cs_project/models/destination.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:travel_planner_app_cs_project/screens/settings_screen.dart';

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
    final RoundedLoadingButtonController makePlanBtnController =
        RoundedLoadingButtonController();

    void _doSomething() async {
      Timer(const Duration(seconds: 3), () {
        // makePlanBtnController.success();
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SettingsScreen()),
        );
      });
    }

    TabController tabController = TabController(length: 4, vsync: this);
    return Scaffold(
      body: ListView(
        children: [
          Stack(
            children: [
              Hero(
                tag: widget.destination.mainImageUrl,
                child: Image(
                  image: AssetImage(widget.destination.detailsImageUrl),
                  height: MediaQuery.of(context).size.height * 0.4,
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 30.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back_ios),
                      color: Colors.white,
                      iconSize: 30.0,
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.favorite),
                      color: Theme.of(context).primaryColor,
                      iconSize: 35.0,
                    ),
                  ],
                ),
              ),
            ],
          ),
          Material(
            elevation: 10,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(50),
              topRight: Radius.circular(50),
            ),
            child: Container(
              height: 436,
              width: 500,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50),
                  topRight: Radius.circular(50),
                ),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 20.0,
                      right: 20,
                      top: 10,
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
                              '\$${widget.destination.price}',
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
                          padding: const EdgeInsets.only(left: 6.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Wrap(
                                children: [
                                  const Icon(
                                    Icons.star,
                                    color: Color.fromARGB(255, 254, 229, 0),
                                    size: 20,
                                  ),
                                  Text('${widget.destination.rating} (2.7K)'),
                                ],
                              ),
                              const Text(
                                '*Estimated Cost',
                                style: TextStyle(
                                  fontSize: 14.0,
                                ),
                              )
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
                                const EdgeInsets.only(left: 20, right: 20),
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
                              Tab(text: "Details"),
                              Tab(text: "Reviews"),
                              Tab(text: "Costs"),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 20.0, right: 20, bottom: 5),
                    child: Text(
                      widget.destination.description,
                      style: const TextStyle(
                        color: Color.fromRGBO(165, 167, 172, 1),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
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
                    padding: const EdgeInsets.only(left: 76),
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
                          width: 63,
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
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          RoundedLoadingButton(
                            height: 50.0,
                            color: Theme.of(context).primaryColor,
                            width: MediaQuery.of(context).size.width * 0.8,
                            successColor: Theme.of(context).primaryColor,
                            resetDuration: const Duration(seconds: 5),
                            controller: makePlanBtnController,
                            onPressed: () => _doSomething(),
                            resetAfterDuration: true,
                            valueColor: Colors.white,
                            borderRadius: 30,
                            child: const Text(
                              'Start planning',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
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
