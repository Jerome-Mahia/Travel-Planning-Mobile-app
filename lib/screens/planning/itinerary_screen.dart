import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:travel_planner_app_cs_project/data/step_guide.dart';

class ItineraryTab extends StatefulWidget {
  const ItineraryTab({super.key});

  @override
  State<ItineraryTab> createState() => _ItineraryTabState();
}

class _ItineraryTabState extends State<ItineraryTab> {
  String notes = """
# Tips, To-Dos, and Packing List

## Tips
- Research local customs and traditions.
- Make digital copies of important documents.
- Check the weather forecast and pack accordingly.
- Learn basic phrases in the local language.

## To-Dos
- Make a list of attractions or activities.
- Create a flexible itinerary.
- Set up travel alerts or notifications.

## Packing List
- Electronics: Smartphone, charger, adapters.
- Travel Essentials: Passport, wallet, itinerary, locks.
- Miscellaneous: Laundry detergent, snacks, umbrella.""";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => guide.screen,
                          ),
                        );
                      },
                      child: Container(
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
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Divider(
                  color: Colors.grey[600],
                  thickness: 1.0,
                ),
              ),
              Align(
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
                        EdgeInsets.symmetric(vertical: 10.0),
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
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Divider(
                  color: Colors.grey[600],
                  thickness: 1.0,
                ),
              ),
              Text(
                'Notes',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 35.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Markdown(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                data: notes,
                styleSheet: MarkdownStyleSheet(
                  p: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w400),
                ),
              ),
            ],
          ),
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
            style: TextStyle(fontSize: 17.0),
          ),
          trailing: SizedBox(
            width: MediaQuery.of(context).size.width * 0.65,
            child: TextField(
              keyboardType: TextInputType.multiline,
              maxLines: 3,
              onTapOutside: (focusNode) {
                FocusScope.of(context).requestFocus(FocusNode());
              },
              style: TextStyle(fontSize: 18.0),
              decoration: InputDecoration(
                hintText: 'Visit Naivasha National Park',
                hintStyle: TextStyle(fontSize: 18.0),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    width: 3,
                    color: Color.fromARGB(255, 226, 225, 225).withOpacity(0.4),
                  ),
                  borderRadius: BorderRadius.circular(15.0),
                ),
              ),
            ),
          ),
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
