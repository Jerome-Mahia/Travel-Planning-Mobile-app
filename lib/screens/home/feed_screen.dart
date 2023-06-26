import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:travel_planner_app_cs_project/data/data.dart';
import 'package:travel_planner_app_cs_project/models/destination.dart';
import 'package:travel_planner_app_cs_project/screens/home/destination_screens.dart';
import 'package:travel_planner_app_cs_project/widgets/home_appbar_widget.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> with TickerProviderStateMixin {
  late AnimationController _animationController;

  bool isAnimating = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
  }

  @override
  Widget build(BuildContext context) {
    TabController tabController = TabController(length: 5, vsync: this);
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
                    child: Text('No', style: TextStyle(color: Colors.black, fontSize: 20)),
                  ),
                  TextButton(
                    onPressed: () {
                      SystemNavigator.pop();
                    },
                    child: Text('Yes', style: TextStyle(color: Colors.red, fontSize: 20)),
                  ),
                ],
              );
            });
      },
      child: Container(
        color: Colors.black,
        child: SafeArea(
          child: Scaffold(
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 80, child: HomeAppBar()),
                        Align(
                          alignment: Alignment.topLeft,
                          child: const Text(
                            'Find your\nDream Destination',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 30,
                              color: Color.fromARGB(255, 44, 38, 38),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        // TextField(
                        //   decoration: InputDecoration(
                        //     contentPadding: const EdgeInsets.symmetric(
                        //         vertical: 15.0, horizontal: 20),
                        //     fillColor: Colors.grey[200],
                        //     filled: true,
                        //     border: OutlineInputBorder(
                        //       borderRadius: BorderRadius.circular(40.0),
                        //       borderSide: const BorderSide(width: 0.8),
                        //     ),
                        //     enabledBorder: OutlineInputBorder(
                        //       borderRadius: BorderRadius.circular(40.0),
                        //       borderSide: const BorderSide(
                        //         width: 0.8,
                        //         color: Color.fromRGBO(255, 238, 238, 1),
                        //       ),
                        //     ),
                        //     hintText: 'Search for a destination',
                        //     suffixIcon: Container(
                        //       height: 10,
                        //       decoration: BoxDecoration(
                        //         shape: BoxShape.circle,
                        //         color: Theme.of(context).primaryColor,
                        //       ),
                        //       child: Padding(
                        //         padding: const EdgeInsets.only(
                        //           left: 13,
                        //           top: 12,
                        //         ),
                        //         child: GestureDetector(
                        //           onTap: () => changeIcon(),
                        //           child: AnimatedIcon(
                        //             icon: AnimatedIcons.search_ellipsis,
                        //             color: Colors.white,
                        //             progress: _animationController,
                        //           ),
                        //         ),
                        //       ),
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                    Container(
                      alignment: Alignment.topLeft,
                      child: const Text(
                        'Continue Planning',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.8,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: 1,
                          itemBuilder: (context, index) {
                            Destination trip = all_destinations[index];
                            return Row(
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
                                      padding: const EdgeInsets.fromLTRB(
                                          10, 10, 0, 0),
                                      child: Text(
                                        'Trip to ${trip.title}',
                                        style: TextStyle(
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.5,
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
                            );
                          }),
                    ),
                    Container(
                      alignment: Alignment.topLeft,
                      child: const Text(
                        'Popular Destinations',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.8,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: TabBar(
                        labelStyle: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                        ),
                        labelPadding:
                            const EdgeInsets.only(left: 15, right: 15),
                        indicatorSize: TabBarIndicatorSize.label,
                        isScrollable: true,
                        controller: tabController,
                        labelColor: Theme.of(context).primaryColor,
                        unselectedLabelColor: Colors.grey[600],
                        indicator: CircleTabIndicator(
                          color: Theme.of(context).primaryColor,
                          radius: 4,
                        ),
                        tabs: const [
                          Tab(text: "All"),
                          Tab(text: "Coast"),
                          Tab(text: "Rift Valley"),
                          Tab(text: "Central"),
                          Tab(text: "Western"),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 10.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.35,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: all_destinations.length,
                          itemBuilder: (BuildContext context, index) {
                            Destination destination = all_destinations[index];
                            return Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: Stack(
                                children: [
                                  GestureDetector(
                                    onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              DestinationScreen(
                                                destination: destination,
                                              )),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(15.0),
                                      child: Hero(
                                        tag: destination.mainImageUrl,
                                        child: Image(
                                          image: AssetImage(
                                              destination.mainImageUrl),
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.35,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.55,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Container(
                                          alignment: Alignment.bottomLeft,
                                          child: Text(
                                            '${destination.title} \nStarting at \$${destination.price}',
                                            style: const TextStyle(
                                              fontSize: 15,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Container(
                                        height: 35,
                                        margin: const EdgeInsets.only(top: 210),
                                        decoration: const BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                        ),
                                        child: IconButton(
                                          onPressed: () {},
                                          icon: const Icon(
                                            Icons.favorite,
                                            size: 25,
                                          ),
                                          color: Theme.of(context).primaryColor,
                                          iconSize: 20.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    // const SizedBox(
                    //   height: 10,
                    // ),
                    // Container(
                    //   alignment: Alignment.topLeft,
                    //   child: const Text(
                    //     'For you',
                    //     style: TextStyle(
                    //       fontSize: 18,
                    //       fontWeight: FontWeight.bold,
                    //       letterSpacing: 0.8,
                    //       color: Colors.black,
                    //     ),
                    //   ),
                    // ),
                    // Container(
                    //   margin: const EdgeInsets.symmetric(vertical: 10.0),
                    //   decoration: BoxDecoration(
                    //     borderRadius: BorderRadius.circular(15.0),
                    //   ),
                    //   child: SizedBox(
                    //     height: MediaQuery.of(context).size.height * 0.35,
                    //     child: ListView.builder(
                    //       scrollDirection: Axis.horizontal,
                    //       itemCount: all_destinations.length,
                    //       itemBuilder: (BuildContext context, index) {
                    //         var allDestinationsReversed =
                    //             List.from(all_destinations.reversed);
                    //         Destination destination =
                    //             allDestinationsReversed[index];
                    //         return Padding(
                    //           padding: const EdgeInsets.only(right: 10),
                    //           child: Stack(
                    //             children: [
                    //               GestureDetector(
                    //                 onTap: () => Navigator.push(
                    //                   context,
                    //                   MaterialPageRoute(
                    //                       builder: (context) =>
                    //                           DestinationScreen(
                    //                             destination: destination,
                    //                           )),
                    //                 ),
                    //                 child: ClipRRect(
                    //                   borderRadius: BorderRadius.circular(15.0),
                    //                   child: Hero(
                    //                     tag: destination.mainImageUrl,
                    //                     child: Image(
                    //                       image: AssetImage(
                    //                           destination.mainImageUrl),
                    //                       height: MediaQuery.of(context)
                    //                               .size
                    //                               .height *
                    //                           0.35,
                    //                       width: MediaQuery.of(context)
                    //                               .size
                    //                               .width *
                    //                           0.55,
                    //                       fit: BoxFit.cover,
                    //                     ),
                    //                   ),
                    //                 ),
                    //               ),
                    //               Row(
                    //                 mainAxisAlignment:
                    //                     MainAxisAlignment.spaceBetween,
                    //                 children: [
                    //                   Padding(
                    //                     padding: const EdgeInsets.all(10.0),
                    //                     child: Container(
                    //                       alignment: Alignment.bottomLeft,
                    //                       child: Text(
                    //                         '${destination.title} \nStarting at \$${destination.price}',
                    //                         style: const TextStyle(
                    //                           fontSize: 15,
                    //                           color: Colors.white,
                    //                         ),
                    //                       ),
                    //                     ),
                    //                   ),
                    //                   const SizedBox(
                    //                     width: 10,
                    //                   ),
                    //                   Container(
                    //                     height: 35,
                    //                     margin: const EdgeInsets.only(top: 210),
                    //                     decoration: const BoxDecoration(
                    //                       color: Colors.white,
                    //                       shape: BoxShape.circle,
                    //                     ),
                    //                     child: Align(
                    //                       alignment: Alignment.center,
                    //                       child: IconButton(
                    //                         onPressed: () {},
                    //                         icon: const Icon(
                    //                           Icons.favorite,
                    //                           size: 25,
                    //                         ),
                    //                         color:
                    //                             Theme.of(context).primaryColor,
                    //                         iconSize: 20.0,
                    //                       ),
                    //                     ),
                    //                   ),
                    //                 ],
                    //               ),
                    //             ],
                    //           ),
                    //         );
                    //       },
                    //     ),
                    //   ),
                    // ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void changeIcon() {
//rebuilds UI with changing icon.
    setState(() {
      isAnimating = !isAnimating;
      isAnimating
          ? _animationController.forward()
          : _animationController.reverse();
    });
  }

//disposes AnimationController.
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
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
