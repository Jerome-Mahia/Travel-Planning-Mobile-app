import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:travel_planner_app_cs_project/data/step_guide.dart';
import 'package:travel_planner_app_cs_project/screens/planning/itinerary_screen.dart';

class OverviewTab extends StatefulWidget {
  const OverviewTab({super.key});

  @override
  State<OverviewTab> createState() => _OverviewTabState();
}

class _OverviewTabState extends State<OverviewTab> {
  String termsAndConditionsIntro = """
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
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 10,
              ),
              Text(
                'Itinerary',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 35.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              ListView.builder(
                itemCount: dates.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, i) {
                  return ExpansionTile(
                    maintainState: true,
                    tilePadding: EdgeInsets.symmetric(vertical: 10.0),
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
                data: termsAndConditionsIntro,
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
          trailing: Text(
            'Visit Naivasha National Park',
            style: TextStyle(fontSize: 18.0),
          ),
        ),
      );

    return columnContent;
  }
}
