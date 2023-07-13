import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:travel_planner_app_cs_project/models/create_itinerary.dart';
import 'package:travel_planner_app_cs_project/models/items.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:travel_planner_app_cs_project/screens/planning/trip_detail_screen.dart';

class ExtraInfoScreen extends StatefulWidget {
  const ExtraInfoScreen(
      {super.key,
      required this.destination,
      required this.startDate,
      required this.endDate});
  final String destination;
  final String startDate;
  final String endDate;

  @override
  State<ExtraInfoScreen> createState() => _ExtraInfoScreenState();
}

List<Item> selectedItems = [];

String? valueChoose;

String agetypeDropdownValue = "Select one";
String excitementtypeDropdownValue = "Select one";
String budgettypeDropdownValue = "Select one";

class _ExtraInfoScreenState extends State<ExtraInfoScreen> {
  TextEditingController destinationInput = TextEditingController();
  final _planFormKey = GlobalKey<FormState>();

  final RoundedLoadingButtonController makePlanBtnController =
      RoundedLoadingButtonController();

  // void _doSomething(RoundedLoadingButtonController controller) async {
  //   Timer(const Duration(seconds: 1), () {
  //     Navigator.push(context, MaterialPageRoute(builder: (context) {
  //       return TripDetailScreen();
  //     }));
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Center(child: Text('Travel Preferences')),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Form(
              key: _planFormKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Text(
                  //   'Select the type of crowd you are travelling with',
                  //   textAlign: TextAlign.center,
                  //   style: TextStyle(
                  //     fontSize: 18.0,
                  //     fontWeight: FontWeight.w500,
                  //     color: Colors.grey[700],
                  //   ),
                  // ),
                  // SizedBox(
                  //   height: 20,
                  // ),
                  // GridView.builder(
                  //   itemCount: dataList.length,
                  //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  //     crossAxisCount: 2,
                  //     childAspectRatio: 1.0,
                  //     crossAxisSpacing: 15.0,
                  //     mainAxisSpacing: 15.0,
                  //   ),
                  //   shrinkWrap: true,
                  //   physics: NeverScrollableScrollPhysics(),
                  //   itemBuilder: (BuildContext context, int index) {
                  //     final item = dataList[index];
                  //     return GestureDetector(
                  //       // Add a key to each item
                  //       onTap: () {
                  //         setState(() {
                  //           item.isChosen = !item.isChosen;
                  //           if (item.isChosen == true &&
                  //               selectedItems.isEmpty) {
                  //             selectedItems
                  //                 .add(Item(item.image, item.title, true));
                  //           } else if (item.isChosen == false) {
                  //             selectedItems.removeWhere(
                  //                 (element) => element.title == item.title);
                  //             if (!selectedItems.contains(item)) {
                  //               item.isChosen = false;
                  //             }
                  //           }
                  //         });
                  //       },
                  //       child: Column(
                  //         children: [
                  //           Container(
                  //             height: MediaQuery.of(context).size.height * 0.18,
                  //             decoration: BoxDecoration(
                  //               borderRadius:
                  //                   BorderRadius.all(Radius.circular(16.0)),
                  //               border: item.isChosen == false
                  //                   ? Border.all(
                  //                       color: Colors.grey,
                  //                       width: 1.0,
                  //                     )
                  //                   : Border.all(
                  //                       color: Theme.of(context).primaryColor,
                  //                       width: 1.0,
                  //                     ),
                  //             ),
                  //             child: Padding(
                  //               padding: const EdgeInsets.all(4.0),
                  //               child: SvgPicture.asset(
                  //                 item.image,
                  //                 fit: BoxFit.cover,
                  //               ),
                  //             ),
                  //           ),
                  //           Center(
                  //             child: Text(
                  //               item.title,
                  //               style: TextStyle(
                  //                 fontSize: 18.0,
                  //                 fontWeight: FontWeight.w500,
                  //                 color: item.isChosen == false
                  //                     ? Colors.grey[700]
                  //                     : Theme.of(context).primaryColor,
                  //               ),
                  //             ),
                  //           ),
                  //         ],
                  //       ),
                  //     );
                  //   },
                  // ),
                  // SizedBox(
                  //   height: 20,
                  // ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              'Age Restriction',
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey[700],
                              ),
                            ),
                          ),
                          DropdownButton<String>(
                            hint: Text("Select one"),
                            underline: Container(
                              height: 2,
                              color: Colors.grey,
                            ),
                            borderRadius: BorderRadius.circular(15),
                            isExpanded: false,
                            dropdownColor: Color.fromARGB(232, 255, 255, 255),
                            icon: Icon(Icons.arrow_drop_down),
                            iconSize: 30,
                            value: agetypeDropdownValue,
                            style: TextStyle(color: Colors.white),
                            onChanged: (String? newValue) {
                              setState(() {
                                agetypeDropdownValue = newValue!;
                              });
                            },
                            items: [
                              DropdownMenuItem<String>(
                                  value: 'Select one',
                                  child: Text(
                                    "Select one",
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 18),
                                  )),
                              DropdownMenuItem<String>(
                                  value: 'Kid friendly',
                                  child: Text(
                                    "Kid friendly",
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 18),
                                  )),
                              DropdownMenuItem<String>(
                                  value: 'adult focused',
                                  child: Text(
                                    "Adults focused",
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 18),
                                  )),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              'Outdoors activities',
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey[700],
                              ),
                            ),
                          ),
                          DropdownButton<String>(
                            hint: Text("Select one"),
                            underline: Container(
                              height: 2,
                              color: Colors.grey,
                            ),
                            borderRadius: BorderRadius.circular(15),
                            isExpanded: false,
                            dropdownColor: Color.fromARGB(232, 255, 255, 255),
                            icon: Icon(Icons.arrow_drop_down),
                            iconSize: 30,
                            value: excitementtypeDropdownValue,
                            style: TextStyle(color: Colors.white),
                            onChanged: (String? newValue) {
                              setState(() {
                                excitementtypeDropdownValue = newValue!;
                              });
                            },
                            items: [
                              DropdownMenuItem<String>(
                                  value: 'Select one',
                                  child: Text(
                                    "Select one",
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 18),
                                  )),
                              DropdownMenuItem<String>(
                                  value: 'fun',
                                  child: Text(
                                    "Fun",
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 18),
                                  )),
                              DropdownMenuItem<String>(
                                  value: 'Educational',
                                  child: Text(
                                    "Educational",
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 18),
                                  )),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              'Price',
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey[700],
                              ),
                            ),
                          ),
                          DropdownButton<String>(
                            hint: Text("Select one"),
                            underline: Container(
                              height: 2,
                              color: Colors.grey,
                            ),
                            borderRadius: BorderRadius.circular(15),
                            isExpanded: false,
                            dropdownColor: Color.fromARGB(232, 255, 255, 255),
                            icon: Icon(Icons.arrow_drop_down),
                            iconSize: 30,
                            value: budgettypeDropdownValue,
                            style: TextStyle(color: Colors.white),
                            onChanged: (String? newValue) {
                              setState(() {
                                budgettypeDropdownValue = newValue!;
                              });
                            },
                            items: [
                              DropdownMenuItem<String>(
                                  value: 'Select one',
                                  child: Text(
                                    "Select one",
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 18),
                                  )),
                              DropdownMenuItem<String>(
                                  value: 'budget friendly',
                                  child: Text(
                                    "Budget friendly",
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 18),
                                  )),
                              DropdownMenuItem<String>(
                                  value: 'Luxury',
                                  child: Text(
                                    "Luxury",
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 18),
                                  )),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Center(
                              child: InkWell(
                                onTap: () {
                                  createItinerary(
                                    context,
                                    'Trip to ${widget.destination}',
                                    '',
                                    widget.destination,
                                    widget.startDate,
                                    widget.endDate,
                                    [],
                                    agetypeDropdownValue,
                                    excitementtypeDropdownValue,
                                    budgettypeDropdownValue,
                                  );
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => TripDetailScreen(),
                                    ),
                                  );
                                },
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
                                      'Start planning',
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
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
