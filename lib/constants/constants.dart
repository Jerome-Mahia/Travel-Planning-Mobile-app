import 'package:latlong2/latlong.dart';

class AppConstants {
  static const String mapBoxAccessToken =
      "pk.eyJ1Ijoiam1haGlhIiwiYSI6ImNsamZjaHFqazAwamYzY281aGdnanUxZWcifQ.OFu4IfHYmORn4LbQ_ot5QQ";

  static const String mapBoxStyleId = 'YOUR_STYLE_ID';

  static const String mapBoxUrl =
      'https://api.mapbox.com/styles/v1/jmahia/clf5gf7zq006j01pgkxor41cp/tiles/256/{z}/{x}/{y}@2x?access_token=$mapBoxAccessToken';

  static final myLocation = const LatLng(51.5090214, -0.1982948);
}
