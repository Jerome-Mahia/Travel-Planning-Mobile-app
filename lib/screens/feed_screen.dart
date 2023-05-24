import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:travel_planner_app_cs_project/data/data.dart';
import 'package:travel_planner_app_cs_project/models/destination.dart';
import 'package:travel_planner_app_cs_project/screens/destination_screens.dart';
import 'package:travel_planner_app_cs_project/widgets/bottom_navbar.dart';

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
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: AppBar(
          elevation: 0.0,
          leading: Padding(
            padding: const EdgeInsets.all(15.0),
            child: GestureDetector(
              onTap: () => changeIcon(),
              child: AnimatedIcon(
                size: 40,
                icon: AnimatedIcons.menu_close,
                color: Colors.black,
                progress: _animationController,
              ),
            ),
          ),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: IconButton(
                color: Colors.black,
                onPressed: () {},
                iconSize: 40,
                icon: Icon(
                  Icons.account_box_rounded,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
          ],
        ),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Discover',
                  style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.8,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  'Explore the best places in Kenya!',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.8,
                    color: Color.fromRGBO(165, 167, 172, 1),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 20),
                      fillColor: Colors.grey[200],
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(40.0),
                        borderSide: const BorderSide(width: 0.8),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(40.0),
                        borderSide: const BorderSide(
                          width: 0.8,
                          color: Color.fromRGBO(255, 238, 238, 1),
                        ),
                      ),
                      hintText: 'Search for a destination',
                      suffixIcon: Container(
                        height: 10,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Theme.of(context).primaryColor,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left: 13,
                            top: 12,
                          ),
                          child: GestureDetector(
                            onTap: () => changeIcon(),
                            child: AnimatedIcon(
                              icon: AnimatedIcons.search_ellipsis,
                              color: Colors.white,
                              progress: _animationController,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
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
          ),
          Container(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: TabBar(
                  labelPadding: const EdgeInsets.only(left: 20, right: 20),
                  indicatorSize: TabBarIndicatorSize.label,
                  isScrollable: true,
                  controller: tabController,
                  labelColor: Theme.of(context).primaryColor,
                  unselectedLabelColor: Colors.grey,
                  indicator: CircleTabIndicator(
                      color: Theme.of(context).primaryColor, radius: 4),
                  tabs: const [
                    Tab(text: "All"),
                    Tab(text: "America"),
                    Tab(text: "Europe"),
                    Tab(text: "Asia"),
                    Tab(text: "Oceania"),
                  ],
                ),
              ),
            ),
          ),
          Container(
            margin:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
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
                    padding: const EdgeInsets.only(right: 30),
                    child: Stack(
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DestinationScreen(
                                      destination: destination,
                                    )),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15.0),
                            child: Hero(
                              tag: destination.mainImageUrl,
                              child: Image(
                                image: AssetImage(destination.mainImageUrl),
                                height:
                                    MediaQuery.of(context).size.height * 0.35,
                                width: MediaQuery.of(context).size.width * 0.55,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              alignment: Alignment.topLeft,
              child: const Text(
                'Popular Categories',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.8,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: const EdgeInsets.all(10),
                width: 70,
                height: 70,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: AssetImage(
                        'assets/icons/icons8-airplane-take-off-100.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(10),
                width: 70,
                height: 70,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: AssetImage('assets/icons/icons8-building-100.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(10),
                width: 70,
                height: 70,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: AssetImage('assets/icons/icons8-car-50.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(10),
                width: 70,
                height: 70,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: AssetImage('assets/icons/icons8-confetti-100.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 50),
            child: Row(
              children: const [
                Text(
                  'Trips',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 17,
                    letterSpacing: 0.8,
                    color: Color.fromRGBO(165, 167, 172, 1),
                  ),
                ),
                SizedBox(
                  width: 49,
                ),
                Text(
                  'Hotel',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 17,
                    letterSpacing: 0.8,
                    color: Color.fromRGBO(165, 167, 172, 1),
                  ),
                ),
                SizedBox(
                  width: 23,
                ),
                Text(
                  'Transport',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 17,
                    letterSpacing: 0.8,
                    color: Color.fromRGBO(165, 167, 172, 1),
                  ),
                ),
                SizedBox(
                  width: 29,
                ),
                Text(
                  'Events',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 17,
                    letterSpacing: 0.8,
                    color: Color.fromRGBO(165, 167, 172, 1),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              alignment: Alignment.topLeft,
              child: const Text(
                'For you',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.8,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          Container(
            margin:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.35,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: all_destinations.length,
                itemBuilder: (BuildContext context, index) {
                  var allDestinationsReversed = List.from(all_destinations.reversed);
                  Destination destination = allDestinationsReversed[index];
                  return Padding(
                    padding: const EdgeInsets.only(right: 30),
                    child: Stack(
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DestinationScreen(
                                      destination: destination,
                                    )),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15.0),
                            child: Hero(
                              tag: destination.mainImageUrl,
                              child: Image(
                                image: AssetImage(destination.mainImageUrl),
                                height:
                                    MediaQuery.of(context).size.height * 0.35,
                                width: MediaQuery.of(context).size.width * 0.55,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                              child: Align(
                                alignment: Alignment.center,
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
          const SizedBox(
            height: 20,
          ),
        ],
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
