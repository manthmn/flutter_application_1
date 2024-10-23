import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class UserData {
  static Position? currentPosition;
  static List<Placemark>? placemarks;
  static Position defaultPosition = Position(
    latitude: 51.5074, // London latitude
    longitude: -0.1278, // London longitude
    timestamp: DateTime.now(),
    accuracy: 0.0,
    altitude: 0.0,
    heading: 0.0,
    speed: 0.0,
    speedAccuracy: 0.0,
    altitudeAccuracy: 0.0,
    headingAccuracy: 0.0,
  );
}
