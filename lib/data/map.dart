import 'package:latlong2/latlong.dart';

class MapMarker {
  final String title;
  final String address;
  final LatLng location;
  final String date;

  MapMarker({
    required this.title,
    required this.address,
    required this.location,
    required this.date,
  });
}

final mapMarkers = [
  MapMarker(
    title: 'Alexander The Great Restaurant',
    address: '8 Plender St, London NW1 0JT, United Kingdom',
    location: LatLng(51.5382123, -0.1882464),
    date: ' Mon, 12 Jul'
  ),
  MapMarker(
    title: 'Mestizo Mexican Restaurant',
    address: '103 Hampstead Rd, London NW1 3EL, United Kingdom',
    location: LatLng(51.5090229, -0.2886548),
    date: ' Tue, 13 Jul'
  ),
  MapMarker(
    title: 'The Shed',
    address: '122 Palace Gardens Terrace, London W8 4RT, United Kingdom',
    location: LatLng(51.5090215, -0.1959988),
    date: ' Wed, 14 Jul'
  ),
  MapMarker(
    title: 'Gaucho Tower Bridge',
    address: '2 More London Riverside, London SE1 2AP, United Kingdom',
    location: LatLng(51.5054563, -0.0798412),
    date: ' Thu, 15 Jul'
  ),
  MapMarker(
    title: 'Bill\'s Holborn Restaurant',
    address: '42 Kingsway, London WC2B 6EY, United Kingdom',
    location: LatLng(51.5077676, -0.2208447),
    date: ' Fri, 16 Jul'
  ),
];
