import 'dart:async';

import 'package:easy_search_bar/easy_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:travel_planner_app_cs_project/widgets/destination_search_widget.dart';

import '../../main.dart';

class PlanningFormScreen extends ConsumerStatefulWidget {
  const PlanningFormScreen({super.key});

  @override
  _PlanningFormScreenState createState() => _PlanningFormScreenState();
}

class _PlanningFormScreenState extends ConsumerState<PlanningFormScreen> {
  bool _isEnabled = true;
  final _planFormKey = GlobalKey<FormState>();
  String selectedDestination = ''; // Define selectedDestination as a field

  final RoundedLoadingButtonController makePlanBtnController =
      RoundedLoadingButtonController();

  void _doSomething() async {
    Timer(const Duration(seconds: 2), () {});
  }

  TextEditingController dateRangeInput = TextEditingController();
  TextEditingController destinationInput = TextEditingController();

  @override
  void initState() {
    dateRangeInput.text = ""; // Set the initial value of the text field
    destinationInput.text = "";
    super.initState();
  }

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
                          'Build an itinerary for your trip and create your own travel adventure.',
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
                                "Select destination E.g Naivasha, Nakuru", // Label text of field
                            labelStyle: TextStyle(
                                color: Colors.grey[700],
                                fontSize: 16.0,
                                letterSpacing: 0.5),
                          ),
                          readOnly:
                              true, // Set it to true, so that the user cannot edit the text
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
                                destinationInput.text =
                                    '$destinationValue'; // Set output date range to TextField value
                              });
                            }
                          },
                        ),
                        TextFormField(
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
                          onTap: () async {
                            DateTimeRange? pickedDateRange =
                                await showDateRangePicker(
                              context: context,
                              firstDate: DateTime(1950),
                              // DateTime.now() - not allowing to choose before today
                              lastDate: DateTime(2100),
                              builder: (context, child) {
                                final calendarTheme = ThemeData(
                                  colorScheme: ColorScheme.light(
                                    surface:
                                        const Color.fromRGBO(255, 69, 91, 1),
                                    tertiary:
                                        const Color.fromRGBO(255, 69, 91, 1),
                                    surfaceTint:
                                        const Color.fromRGBO(255, 69, 91, 1),
                                    primary:
                                        const Color.fromRGBO(255, 69, 91, 1),
                                    onPrimary: Colors.white,
                                    onTertiary: Colors.white,
                                  ),
                                  textButtonTheme: TextButtonThemeData(
                                    style: TextButton.styleFrom(
                                      primary: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                );
                                return Theme(
                                  data: calendarTheme,
                                  child: child!,
                                );
                              },
                            );
                            if (pickedDateRange != null) {
                              String formattedStartDate = DateFormat('MMM d')
                                  .format(pickedDateRange.start);
                              String formattedEndDate = DateFormat('MMM d')
                                  .format(pickedDateRange.end);
                              setState(() {
                                dateRangeInput.text =
                                    '$formattedStartDate - $formattedEndDate'; // Set output date range to TextField value
                              });
                            }
                          },
                        ),
                        const SizedBox(
                          height: 38.0,
                        ),
                        RoundedLoadingButton(
                          height: 55.0,
                          color: Theme.of(context).primaryColor,
                          width: MediaQuery.of(context).size.width * 0.9,
                          successColor: Theme.of(context).primaryColor,
                          resetDuration: const Duration(seconds: 3),
                          controller: makePlanBtnController,
                          onPressed: () {
                            if (_planFormKey.currentState!.validate()) {
                              _doSomething();
                            } else {
                              makePlanBtnController.error();
                            }
                          },
                          resetAfterDuration: true,
                          valueColor: Colors.white,
                          borderRadius: 15,
                          child: const Text(
                            'Make Itinerary',
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
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
      ),
    );
  }
}
