import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:stop_finder/models/nearby_stops.dart';
import 'package:stop_finder/models/vehicle_details.dart';

class PlaceRepository {
  final String _baseUrl = "https://api.tfl.gov.uk"; // Base URL for API
  final String _stopType = "NaptanPublicBusCoachTram"; // Stop type for API queries
  final Logger _logger = Logger(); // Logger for debugging

  // Fetch nearby bus stops based on latitude and longitude
  Future<List<StopPoint>> getNearbyStops(double lat, double lon) async {
    final url = '$_baseUrl/StopPoint?stopTypes=$_stopType&lat=$lat&lon=$lon';
    _logger.i('Request: GET $url');

    final response = await http.get(Uri.parse(url));

    _logger.i('Response Status Code: ${response.statusCode}');
    _logger.d('Response Body: ${response.body}');

    if (response.statusCode == 200) {
      final data = NearbyStops.fromJson(json.decode(response.body));
      return data.stopPoints ?? []; // Return list of nearby stops
    } else {
      _logger.e('Error: ${response.body}');
      throw Exception(json.decode(response.body)?["message"] ?? 'Failed to load stops');
    }
  }

  // Fetch bus arrivals for a specific stop
  Future<List<VehicleDetails>> getBusArrivals(String stopPointId) async {
    final url = '$_baseUrl/StopPoint/$stopPointId/Arrivals';
    _logger.i('Request: GET $url');

    final response = await http.get(Uri.parse(url));

    _logger.i('Response Status Code: ${response.statusCode}');
    _logger.d('Response Body: ${response.body}');

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data as List).map((e) => VehicleDetails.fromJson(e)).toList(); // Return list of arrivals
    } else {
      _logger.e('Error: ${response.body}');
      throw Exception('Failed to load bus arrivals');
    }
  }
}
