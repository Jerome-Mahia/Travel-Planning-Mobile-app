import 'package:latlong2/latlong.dart';

class MapMarker {
  final String activity;
  final String budget;
  final LatLng location;
  final String date;
  final String timeOfDay;

  MapMarker({
    required this.activity,
    required this.budget,
    required this.location,
    required this.date,
    required this.timeOfDay,
  });
}


