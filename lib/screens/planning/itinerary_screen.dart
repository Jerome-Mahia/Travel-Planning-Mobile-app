import 'package:flutter/material.dart';
import 'package:travel_planner_app_cs_project/data/step_guide.dart';

class ItineraryTab extends StatefulWidget {
  const ItineraryTab({super.key});

  @override
  State<ItineraryTab> createState() => _ItineraryTabState();
}

class _ItineraryTabState extends State<ItineraryTab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 120.0,
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.only(left: 10.0),
                scrollDirection: Axis.horizontal,
                itemCount: guides.length,
                itemBuilder: (BuildContext context, int index) {
                  StepGuide guide = guides[index];
                  return Container(
                    margin: const EdgeInsets.all(10.0),
                    width: MediaQuery.of(context).size.width / 1.5,
                    decoration: BoxDecoration(
                      color:
                          Color.fromARGB(255, 226, 225, 225).withOpacity(0.4),
                      borderRadius: BorderRadius.circular(15.0),
                      // border: Border.all(
                      //   width: 1.0,
                      //   color: Colors.grey,
                      // ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            guide.title,
                            style: const TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 6.0),
                          Text(
                            guide.description,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 16.0,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'Itinerary',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 35.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            ListView.builder(
              itemCount: dates.length,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, i) {
                return ExpansionTile(
                  maintainState: true,
                  tilePadding:
                      EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                  title: Text(
                    dates[i].title,
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  children: <Widget>[
                    Column(
                      children: _buildExpandableContent(dates[i]),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  _buildExpandableContent(Date vehicle) {
    List<Widget> columnContent = [];

    for (String content in vehicle.contents)
      columnContent.add(
        ListTile(
          title: Text(
            content,
            style: TextStyle(fontSize: 18.0),
          ),
          trailing: Text('Visit Naivasha National Park',
              style: TextStyle(fontSize: 18.0)),
        ),
      );

    return columnContent;
  }
}

class Date {
  final String title;
  List<String> contents = [];

  Date(this.title, this.contents);
}

List<Date> dates = [
  Date(
    'Mon 1/8',
    ['Morning', 'Afternoon', 'Evening'],
  ),
  Date(
    'Tue 2/8',
    ['Morning', 'Afternoon', 'Evening'],
  ),
  Date(
    'Wed 3/8',
    ['Morning', 'Afternoon', 'Evening'],
  ),
  Date(
    'Thu 4/8',
    ['Morning', 'Afternoon', 'Evening'],
  ),
];
