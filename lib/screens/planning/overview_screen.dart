import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:intl/intl.dart';
import 'package:travel_planner_app_cs_project/data/step_guide.dart';
import 'package:travel_planner_app_cs_project/screens/planning/itinerary_screen.dart';

import '../../models/fetch_itinerary_details.dart';

class OverviewTab extends StatefulWidget {
  const OverviewTab({super.key, required this.tripDays});
  final List<Day>? tripDays;

  @override
  State<OverviewTab> createState() => _OverviewTabState();
}

class _OverviewTabState extends State<OverviewTab> {
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
                itemCount: widget.tripDays!.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  Day dailyActivities = widget.tripDays![index];
                  // Day dailyActivities = widget.tripDays[index];
                  String formattedDate =
                      DateFormat.E().add_d().format(dailyActivities.date);
                  return ExpansionTile(
                    maintainState: true,
                    tilePadding: EdgeInsets.symmetric(vertical: 10.0),
                    title: Text(
                      formattedDate,
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              'Morning',
                              style: TextStyle(
                                fontSize: 17.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Text(
                            dailyActivities.morningActivity,
                            style: TextStyle(fontSize: 18.0),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              'Afternoon',
                              style: TextStyle(
                                fontSize: 17.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Text(
                            dailyActivities.afternoonActivity,
                            style: TextStyle(fontSize: 18.0),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              'Evening',
                              style: TextStyle(
                                fontSize: 17.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Text(
                            dailyActivities.eveningActivity,
                            style: TextStyle(fontSize: 18.0),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10.0,
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
              // Padding(
              //   padding: const EdgeInsets.all(10.0),
              //   child: Divider(
              //     color: Colors.grey[600],
              //     thickness: 1.0,
              //   ),
              // ),
              // Text(
              //   'Flights',
              //   style: TextStyle(
              //     color: Colors.black,
              //     fontSize: 35.0,
              //     fontWeight: FontWeight.bold,
              //   ),
              // ),
              // SizedBox(
              //   height: 10.0,
              // ),
              // Container(
              //   padding:
              //       EdgeInsets.only(top: 25, bottom: 25, right: 17, left: 17),
              //   decoration: BoxDecoration(
              //     borderRadius: BorderRadius.circular(25),
              //     color: Color.fromARGB(255, 226, 225, 225).withOpacity(0.4),
              //   ),
              //   child: Column(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       Row(
              //         mainAxisAlignment: MainAxisAlignment.start,
              //         children: [
              //           Wrap(
              //             direction: Axis.vertical,
              //             children: [
              //               Text(
              //                 "NBO",
              //                 style: TextStyle(
              //                   fontSize: 18,
              //                   fontWeight: FontWeight.w600,
              //                 ),
              //               ),
              //               Text(
              //                 "Nairobi",
              //                 style: TextStyle(
              //                   fontSize: 16,
              //                 ),
              //               ),
              //             ],
              //           ),
              //           SizedBox(width: 10),
              //           Icon(
              //             Icons.forward,
              //             color: Theme.of(context).primaryColor,
              //             size: 25,
              //           ),
              //           SizedBox(width: 10),
              //           Wrap(
              //             direction: Axis.vertical,
              //             children: [
              //               Text(
              //                 "MBA",
              //                 style: TextStyle(
              //                   fontSize: 18,
              //                   fontWeight: FontWeight.w600,
              //                 ),
              //               ),
              //               Text(
              //                 "Mombasa",
              //                 style: TextStyle(
              //                   fontSize: 16,
              //                 ),
              //               ),
              //             ],
              //           ),
              //         ],
              //       ),
              //       Row(
              //         mainAxisAlignment: MainAxisAlignment.start,
              //         children: [
              //           Text(
              //             "Fri, 12 Nov 2021",
              //             style: TextStyle(
              //               fontSize: 16,
              //             ),
              //           ),
              //           SizedBox(width: 5),
              //           Container(
              //             width: 6,
              //             height: 6,
              //             decoration: BoxDecoration(
              //               color: Colors.black,
              //               shape: BoxShape.circle,
              //             ),
              //           ),
              //           SizedBox(width: 5),
              //           Text(
              //             "6:00 AM - 8:30 AM",
              //             style: TextStyle(
              //               fontSize: 16,
              //             ),
              //           ),
              //         ],
              //       ),
              //       Row(
              //         mainAxisAlignment: MainAxisAlignment.start,
              //         children: [
              //           Text(
              //             "1 Adult",
              //             style: TextStyle(
              //               fontSize: 16,
              //             ),
              //           ),
              //           SizedBox(width: 5),
              //           Container(
              //             width: 6,
              //             height: 6,
              //             decoration: BoxDecoration(
              //               color: Colors.black,
              //               shape: BoxShape.circle,
              //             ),
              //           ),
              //           SizedBox(width: 5),
              //           Text(
              //             "Economy",
              //             style: TextStyle(
              //               fontSize: 16,
              //             ),
              //           ),
              //         ],
              //       ),
              //       Text(
              //         "Kenya Airways",
              //         style: TextStyle(
              //           fontSize: 16,
              //           fontWeight: FontWeight.w500,
              //         ),
              //       ),
              //       Padding(
              //         padding: const EdgeInsets.all(10.0),
              //         child: Divider(
              //           color: Colors.grey[600],
              //           thickness: 1.0,
              //         ),
              //       ),
              //       Row(
              //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //         children: [
              //           Wrap(
              //             direction: Axis.vertical,
              //             children: [
              //               Text(
              //                 "Receipt No",
              //                 style: TextStyle(
              //                   fontSize: 16,
              //                 ),
              //               ),
              //               Text(
              //                 "126789",
              //                 style: TextStyle(
              //                   fontSize: 16,
              //                   fontWeight: FontWeight.w600,
              //                 ),
              //               ),
              //             ],
              //           ),
              //           Chip(
              //             label: Text(
              //               "KES 12,000",
              //               style: TextStyle(
              //                 fontSize: 16,
              //                 fontWeight: FontWeight.w500,
              //               ),
              //             ),
              //             shape: RoundedRectangleBorder(
              //               borderRadius: BorderRadius.circular(20),
              //               side: BorderSide(
              //                 color: Color.fromARGB(255, 226, 225, 225)
              //                     .withOpacity(0.4),
              //               ),
              //             ),
              //             backgroundColor: Color.fromARGB(255, 226, 225, 225)
              //                 .withOpacity(0.4),
              //           ),
              //         ],
              //       ),
              //     ],
              //   ),
              // ),
              // TextButton(
              //   onPressed: () {},
              //   child: Text(
              //     "Add Another Flight",
              //     style: TextStyle(
              //       color: Colors.black54,
              //       fontSize: 16,
              //     ),
              //   ),
              // ),
              // Padding(
              //   padding: const EdgeInsets.all(10.0),
              //   child: Divider(
              //     color: Colors.grey[600],
              //     thickness: 1.0,
              //   ),
              // ),
              // Text(
              //   'Tickets',
              //   style: TextStyle(
              //     color: Colors.black,
              //     fontSize: 35.0,
              //     fontWeight: FontWeight.bold,
              //   ),
              // ),
              // SizedBox(
              //   height: 10.0,
              // ),
              // Container(
              //   padding:
              //       EdgeInsets.only(top: 25, bottom: 25, right: 17, left: 17),
              //   decoration: BoxDecoration(
              //     borderRadius: BorderRadius.circular(25),
              //     color: Color.fromARGB(255, 226, 225, 225).withOpacity(0.4),
              //   ),
              //   child: Column(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       Text(
              //         "Nairobi Museum",
              //         style: TextStyle(
              //           fontSize: 18,
              //           fontWeight: FontWeight.w600,
              //         ),
              //       ),
              //       Text(
              //         "Museum Hill Road, Nairobi",
              //         style: TextStyle(
              //           fontSize: 16,
              //         ),
              //       ),
              //       Row(
              //         mainAxisAlignment: MainAxisAlignment.start,
              //         children: [
              //           Text(
              //             "Fri, 12 Nov 2021",
              //             style: TextStyle(
              //               fontSize: 16,
              //             ),
              //           ),
              //           SizedBox(width: 5),
              //           Container(
              //             width: 6,
              //             height: 6,
              //             decoration: BoxDecoration(
              //               color: Colors.black,
              //               shape: BoxShape.circle,
              //             ),
              //           ),
              //           SizedBox(width: 5),
              //           Text(
              //             "6:00 AM - 8:30 AM",
              //             style: TextStyle(
              //               fontSize: 16,
              //             ),
              //           ),
              //         ],
              //       ),
              //       Padding(
              //         padding: const EdgeInsets.all(10.0),
              //         child: Divider(
              //           color: Colors.grey[600],
              //           thickness: 1.0,
              //         ),
              //       ),
              //       Row(
              //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //         children: [
              //           Wrap(
              //             direction: Axis.vertical,
              //             children: [
              //               Text(
              //                 "Receipt No",
              //                 style: TextStyle(
              //                   fontSize: 16,
              //                 ),
              //               ),
              //               Text(
              //                 "126789",
              //                 style: TextStyle(
              //                   fontSize: 16,
              //                   fontWeight: FontWeight.w600,
              //                 ),
              //               ),
              //             ],
              //           ),
              //           Chip(
              //             label: Text(
              //               "KES 2,000",
              //               style: TextStyle(
              //                 fontSize: 15,
              //                 fontWeight: FontWeight.w500,
              //               ),
              //             ),
              //             shape: RoundedRectangleBorder(
              //               borderRadius: BorderRadius.circular(20),
              //               side: BorderSide(
              //                 color: Color.fromARGB(255, 226, 225, 225)
              //                     .withOpacity(0.4),
              //               ),
              //             ),
              //             backgroundColor: Color.fromARGB(255, 226, 225, 225)
              //                 .withOpacity(0.4),
              //           ),
              //         ],
              //       ),
              //     ],
              //   ),
              // ),
              // TextButton(
              //   onPressed: () {},
              //   child: Text(
              //     "Add Another Ticket",
              //     style: TextStyle(
              //       color: Colors.black54,
              //       fontSize: 16,
              //     ),
              //   ),
              // ),
              // Padding(
              //   padding: const EdgeInsets.all(10.0),
              //   child: Divider(
              //     color: Colors.grey[600],
              //     thickness: 1.0,
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  _buildExpandableContent(Date dates, Day activities) {
    List<Widget> columnContent = [];

    for (String content in dates.contents)
      columnContent.add(
        ListTile(
          title: Text(
            content,
            style: TextStyle(fontSize: 17.0),
          ),
          trailing: Text(
            activities.morningActivity,
            style: TextStyle(fontSize: 18.0),
          ),
        ),
      );

    return columnContent;
  }
}
