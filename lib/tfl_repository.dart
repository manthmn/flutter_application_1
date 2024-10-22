import 'dart:convert';

import 'package:flutter_application_1/bus_arrival.dart';
import 'package:flutter_application_1/nearby_stops.dart';
import 'package:http/http.dart' as http;

class TfLRepository {
  final String _baseUrl = "https://api.tfl.gov.uk";

  Future<List<StopPoint>> getNearbyStops(double lat, double lon) async {
    final response =
        await http.get(Uri.parse('$_baseUrl/StopPoint?stopTypes=NaptanPublicBusCoachTram&lat=$lat&lon=$lon'));

    if (response.statusCode == 200) {
      final data = NearbyStops.fromJson(json.decode(response.body));
      return data.stopPoints;
    } else {
      throw Exception('Failed to load stops');
    }
  }

  Future<List<BusArrival>> getBusArrivals(String stopPointId) async {
    final response = await http.get(Uri.parse('$_baseUrl/StopPoint/$stopPointId/Arrivals'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data as List).map((e) => BusArrival.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load bus arrivals');
    }
  }
}
