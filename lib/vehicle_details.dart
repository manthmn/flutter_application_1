class VehicleDetails {
  VehicleDetails({
    required this.type,
    required this.id,
    required this.operationType,
    required this.vehicleId,
    required this.naptanId,
    required this.stationName,
    required this.lineId,
    required this.lineName,
    required this.platformName,
    required this.direction,
    required this.bearing,
    required this.tripId,
    required this.baseVersion,
    required this.destinationNaptanId,
    required this.destinationName,
    required this.timestamp,
    required this.timeToStation,
    required this.currentLocation,
    required this.towards,
    required this.expectedArrival,
    required this.timeToLive,
    required this.modeName,
    required this.timing,
  });

  final String? type;
  final String? id;
  final int? operationType;
  final String? vehicleId;
  final String? naptanId;
  final String? stationName;
  final String? lineId;
  final String? lineName;
  final String? platformName;
  final String? direction;
  final String? bearing;
  final String? tripId;
  final String? baseVersion;
  final String? destinationNaptanId;
  final String? destinationName;
  final DateTime? timestamp;
  final int? timeToStation;
  final String? currentLocation;
  final String? towards;
  final DateTime? expectedArrival;
  final DateTime? timeToLive;
  final String? modeName;
  final Timing? timing;

  factory VehicleDetails.fromJson(Map<String, dynamic> json) {
    return VehicleDetails(
      type: json["\u0024type"],
      id: json["id"],
      operationType: json["operationType"],
      vehicleId: json["vehicleId"],
      naptanId: json["naptanId"],
      stationName: json["stationName"],
      lineId: json["lineId"],
      lineName: json["lineName"],
      platformName: json["platformName"],
      direction: json["direction"],
      bearing: json["bearing"],
      tripId: json["tripId"],
      baseVersion: json["baseVersion"],
      destinationNaptanId: json["destinationNaptanId"],
      destinationName: json["destinationName"],
      timestamp: DateTime.tryParse(json["timestamp"] ?? ""),
      timeToStation: json["timeToStation"],
      currentLocation: json["currentLocation"],
      towards: json["towards"],
      expectedArrival: DateTime.tryParse(json["expectedArrival"] ?? ""),
      timeToLive: DateTime.tryParse(json["timeToLive"] ?? ""),
      modeName: json["modeName"],
      timing: json["timing"] == null ? null : Timing.fromJson(json["timing"]),
    );
  }
}

class Timing {
  Timing({
    required this.type,
    required this.countdownServerAdjustment,
    required this.source,
    required this.insert,
    required this.read,
    required this.sent,
    required this.received,
  });

  final String? type;
  final String? countdownServerAdjustment;
  final DateTime? source;
  final DateTime? insert;
  final DateTime? read;
  final DateTime? sent;
  final DateTime? received;

  factory Timing.fromJson(Map<String, dynamic> json) {
    return Timing(
      type: json["\u0024type"],
      countdownServerAdjustment: json["countdownServerAdjustment"],
      source: DateTime.tryParse(json["source"] ?? ""),
      insert: DateTime.tryParse(json["insert"] ?? ""),
      read: DateTime.tryParse(json["read"] ?? ""),
      sent: DateTime.tryParse(json["sent"] ?? ""),
      received: DateTime.tryParse(json["received"] ?? ""),
    );
  }
}
