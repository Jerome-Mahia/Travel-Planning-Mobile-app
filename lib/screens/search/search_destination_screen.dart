import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:travel_planner_app_cs_project/screens/search/extra_info_screen.dart';
import 'package:travel_planner_app_cs_project/widgets/destination_search_widget.dart';

class SearchDestinationScreen extends StatefulWidget {
  const SearchDestinationScreen({super.key});

  @override
  State<SearchDestinationScreen> createState() =>
      _SearchDestinationScreenState();
}

class _SearchDestinationScreenState extends State<SearchDestinationScreen> {
  bool _isEnabled = true;
  final _planFormKey = GlobalKey<FormState>();
  String selectedDestination = ''; // Define selectedDestination as a field

  // void _doSomething() async {
  //   Timer(const Duration(seconds: 2), () {
  //     Navigator.push(context, MaterialPageRoute(builder: (context) {
  //       return ExtraInfoScreen();
  //     }));
  //   });
  // }

  TextEditingController dateRangeInput = TextEditingController();
  TextEditingController destinationInput = TextEditingController();

  @override
  void initState() {
    dateRangeInput.text = ""; // Set the initial value of the text field
    destinationInput.text = "";
    super.initState();
  }

  String destinationTitle = '';
  String startDate = '';
  String endDate = '';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          surfaceTintColor: Colors.white,
          backgroundColor: Colors.white,
          centerTitle: true,
          title: const Text('Plan Your Trip'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 20.0, left: 20, right: 20),
            child: Column(
              children: [
                SvgPicture.asset(
                  'assets/images/trip_plan_svg.svg',
                  height: MediaQuery.of(context).size.height * 0.36,
                ),
                Form(
                  key: _planFormKey,
                  child: Align(
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Search for your destination and begin your trip planning!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[700],
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          controller: destinationInput,
                          decoration: InputDecoration(
                            border: UnderlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: const BorderSide(
                                color: Colors.grey,
                                width: 0.5,
                              ),
                            ),
                            icon: Icon(
                              Icons.location_pin,
                              size: 20.0,
                            ), // Icon of text field
                            labelText:
                                "Where do you want to go? (Only Cities)", // Label text of field
                            labelStyle: TextStyle(
                                color: Colors.grey[700],
                                fontSize: 16.0,
                                letterSpacing: 0.5),
                          ),
                          readOnly:
                              true, // Set it to true, so that the user cannot edit the text
                          validator: (value) {
                            // Validate if the value is not empty
                            if (value == null || value.isEmpty) {
                              return 'Please select a destination';
                            }
                            return null;
                          },
                          onTap: () async {
                            final destinationPicked = await showSearch(
                              context: context,
                              delegate: DestinationSearchWidget(
                                onDestinationSelected: (destination) {
                                  setState(() {
                                    selectedDestination = destination;
                                    destinationInput.text = destination;
                                  });
                                },
                              ),
                            );

                            if (destinationPicked != null) {
                              String selectedDestination = destinationPicked;
                              String destinationValue = selectedDestination;
                              setState(() {
                                destinationInput.text = '$destinationValue';
                                destinationTitle = destinationValue;
                              });
                            }
                          },
                        ),
                        TextFormField(
                          keyboardType: TextInputType.datetime,
                          controller: dateRangeInput,
                          // Editing controller of this TextField
                          decoration: InputDecoration(
                            border: UnderlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: const BorderSide(
                                color: Colors.grey,
                                width: 0.5,
                              ),
                            ),
                            icon: Icon(
                              Icons.calendar_today,
                              size: 20.0,
                            ), // Icon of text field
                            labelText:
                                "Select trip dates", // Label text of field
                            labelStyle: TextStyle(
                                color: Colors.grey[700],
                                fontSize: 16.0,
                                letterSpacing: 0.5),
                          ),
                          readOnly:
                              true, // Set it to true, so that the user cannot edit the text
                          validator: (value) {
                            // Validate if the value is not empty
                            if (value == null || value.isEmpty) {
                              return 'Please select a date range';
                            }
                            return null;
                          },
                          onTap: () async {
                            DateTimeRange? pickedDateRange =
                                await showDateRangePicker(
                              context: context,
                              firstDate: DateTime(1950),
                              currentDate: DateTime.now(),
                              lastDate: DateTime(2100),
                            );
                            if (pickedDateRange != null) {
                              String formattedStartDate = DateFormat('MMM d')
                                  .format(pickedDateRange.start);
                              String jsonStartDate = DateFormat('yyyy-MM-dd')
                                  .format(pickedDateRange.start);

                              String formattedEndDate = DateFormat('MMM d')
                                  .format(pickedDateRange.end);
                              String jsonEndDate = DateFormat('yyyy-MM-dd')
                                  .format(pickedDateRange.end);

                              setState(() {
                                dateRangeInput.text =
                                    '$formattedStartDate - $formattedEndDate'; // Set output date range to TextField value
                                startDate = jsonStartDate;
                                endDate = jsonEndDate;
                              });
                            }
                          },
                        ),
                        const SizedBox(
                          height: 38.0,
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
                                    if (_planFormKey.currentState!.validate()) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => ExtraInfoScreen(
                                            destination: destinationTitle,
                                            startDate: startDate,
                                            endDate: endDate,
                                          ),
                                        ),
                                      );

                                      print(destinationTitle);
                                      print(startDate);
                                      print(endDate);
                                      _planFormKey.currentState!.save();
                                    }
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
                                        'Continue',
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
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
