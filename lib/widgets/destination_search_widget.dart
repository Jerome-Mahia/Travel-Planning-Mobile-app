import 'package:flutter/material.dart';

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
final TextEditingController destinationController=TextEditingController();
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, '');
      },
      icon: Icon(Icons.arrow_back),
    );
  }

  @override
Widget buildResults(BuildContext context) {
  if (query.isNotEmpty) {
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
            close(context, result); // Return the selected value to the buildResults method
          },
        );
      },
    );
  }
  
}