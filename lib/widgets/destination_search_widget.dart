import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:travel_planner_app_cs_project/constants/constants.dart';
import 'package:travel_planner_app_cs_project/models/mapbox_suggest.dart';
import 'package:uuid/uuid.dart';

class DestinationSearchWidget extends SearchDelegate<String> {
  final ValueChanged<String> onDestinationSelected;

  DestinationSearchWidget({required this.onDestinationSelected});

  List<String> searchTerms = [
    'Afghanistan',
    'Albania',
    'Algeria',
    'Australia',
    'Brazil',
    'German',
    'Madagascar',
    'Mozambique',
    'Portugal',
    'Zambia'
  ];
  final TextEditingController destinationController = TextEditingController();
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, '');
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.isNotEmpty) {
      Future<MapBoxSuggest> mapBoxSuggest() async {
        try {
          _sessiontoken() {
            var uuid = const Uuid();
            var v4 = uuid.v4();
            return v4;
          }

          final response = await http.get(
            Uri.parse(
                "https://api.mapbox.com/search/searchbox/v1/suggest?q=$query&language=en&country=ke&types=region,city,district&session_token=$_sessiontoken&access_token=${AppConstants.mapBoxAccessToken}"),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
          );
          if (response.statusCode == 200) {
            return MapBoxSuggest.fromJson(jsonDecode(response.body));
          } else {
            throw Exception('Failed to load MapBoxSuggest');
          }
        } catch (e) {
          print(e.toString());
          throw Exception('Failed to send email verification code: $e');
        }
      }

      onDestinationSelected(query);
    }
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> matchQuery = [];
    for (var destination in searchTerms) {
      if (destination.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(destination);
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return ListTile(
          title: Text(result),
          onTap: () {
            close(context,
                result); // Return the selected value to the buildResults method
          },
        );
      },
    );
  }
}
