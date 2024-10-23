class NearbyStops {
  NearbyStops({
    this.type,
    this.centrePoint,
    this.stopPoints,
    this.pageSize,
    this.total,
    this.page,
  });

  final String? type;
  final List<double>? centrePoint;
  final List<StopPoint>? stopPoints;
  final int? pageSize;
  final int? total;
  final int? page;

  factory NearbyStops.fromJson(Map<String, dynamic> json) {
    return NearbyStops(
      type: json["\u0024type"],
      centrePoint: json["centrePoint"] == null ? [] : List<double>.from(json["centrePoint"]!.map((x) => x)),
      stopPoints:
          json["stopPoints"] == null ? [] : List<StopPoint>.from(json["stopPoints"]!.map((x) => StopPoint.fromJson(x))),
      pageSize: json["pageSize"],
      total: json["total"],
      page: json["page"],
    );
  }
}

class StopPoint {
  StopPoint({
    this.type,
    this.naptanId,
    this.indicator,
    this.stopLetter,
    this.modes,
    this.icsCode,
    this.stopType,
    this.stationNaptan,
    this.lines,
    this.lineGroup,
    this.lineModeGroups,
    this.status,
    this.id,
    this.commonName,
    this.distance,
    this.placeType,
    this.additionalProperties,
    this.children,
    this.lat,
    this.lon,
    this.hubNaptanCode,
  });

  final String? type;
  final String? naptanId;
  final String? indicator;
  final String? stopLetter;
  final List<String>? modes;
  final String? icsCode;
  final String? stopType;
  final String? stationNaptan;
  final List<Line>? lines;
  final List<LineGroup>? lineGroup;
  final List<LineModeGroup>? lineModeGroups;
  final bool? status;
  final String? id;
  final String? commonName;
  final double? distance;
  final String? placeType;
  final List<AdditionalProperty>? additionalProperties;
  final List<dynamic>? children;
  final double? lat;
  final double? lon;
  final String? hubNaptanCode;

  factory StopPoint.fromJson(Map<String, dynamic> json) {
    return StopPoint(
      type: json["\u0024type"],
      naptanId: json["naptanId"],
      indicator: json["indicator"],
      stopLetter: json["stopLetter"],
      modes: json["modes"] == null ? [] : List<String>.from(json["modes"]!.map((x) => x)),
      icsCode: json["icsCode"],
      stopType: json["stopType"],
      stationNaptan: json["stationNaptan"],
      lines: json["lines"] == null ? [] : List<Line>.from(json["lines"]!.map((x) => Line.fromJson(x))),
      lineGroup:
          json["lineGroup"] == null ? [] : List<LineGroup>.from(json["lineGroup"]!.map((x) => LineGroup.fromJson(x))),
      lineModeGroups: json["lineModeGroups"] == null
          ? []
          : List<LineModeGroup>.from(json["lineModeGroups"]!.map((x) => LineModeGroup.fromJson(x))),
      status: json["status"],
      id: json["id"],
      commonName: json["commonName"],
      distance: json["distance"],
      placeType: json["placeType"],
      additionalProperties: json["additionalProperties"] == null
          ? []
          : List<AdditionalProperty>.from(json["additionalProperties"]!.map((x) => AdditionalProperty.fromJson(x))),
      children: json["children"] == null ? [] : List<dynamic>.from(json["children"]!.map((x) => x)),
      lat: json["lat"],
      lon: json["lon"],
      hubNaptanCode: json["hubNaptanCode"],
    );
  }
}

class AdditionalProperty {
  AdditionalProperty({
    this.type,
    this.category,
    this.key,
    this.sourceSystemKey,
    this.value,
  });

  final String? type;
  final String? category;
  final String? key;
  final String? sourceSystemKey;
  final String? value;

  factory AdditionalProperty.fromJson(Map<String, dynamic> json) {
    return AdditionalProperty(
      type: json["\u0024type"],
      category: json["category"],
      key: json["key"],
      sourceSystemKey: json["sourceSystemKey"],
      value: json["value"],
    );
  }
}

class LineGroup {
  LineGroup({
    this.type,
    this.naptanIdReference,
    this.stationAtcoCode,
    this.lineIdentifier,
  });

  final String? type;
  final String? naptanIdReference;
  final String? stationAtcoCode;
  final List<String>? lineIdentifier;

  factory LineGroup.fromJson(Map<String, dynamic> json) {
    return LineGroup(
      type: json["\u0024type"],
      naptanIdReference: json["naptanIdReference"],
      stationAtcoCode: json["stationAtcoCode"],
      lineIdentifier: json["lineIdentifier"] == null ? [] : List<String>.from(json["lineIdentifier"]!.map((x) => x)),
    );
  }
}

class LineModeGroup {
  LineModeGroup({
    this.type,
    this.modeName,
    this.lineIdentifier,
  });

  final String? type;
  final String? modeName;
  final List<String>? lineIdentifier;

  factory LineModeGroup.fromJson(Map<String, dynamic> json) {
    return LineModeGroup(
      type: json["\u0024type"],
      modeName: json["modeName"],
      lineIdentifier: json["lineIdentifier"] == null ? [] : List<String>.from(json["lineIdentifier"]!.map((x) => x)),
    );
  }
}

class Line {
  Line({
    this.type,
    this.id,
    this.name,
    this.uri,
    this.lineType,
    this.crowding,
    this.routeType,
    this.status,
  });

  final String? type;
  final String? id;
  final String? name;
  final String? uri;
  final String? lineType;
  final Crowding? crowding;
  final String? routeType;
  final String? status;

  factory Line.fromJson(Map<String, dynamic> json) {
    return Line(
      type: json["\u0024type"],
      id: json["id"],
      name: json["name"],
      uri: json["uri"],
      lineType: json["type"],
      crowding: json["crowding"] == null ? null : Crowding.fromJson(json["crowding"]),
      routeType: json["routeType"],
      status: json["status"],
    );
  }
}

class Crowding {
  Crowding({
    this.type,
  });

  final String? type;

  factory Crowding.fromJson(Map<String, dynamic> json) {
    return Crowding(
      type: json["\u0024type"],
    );
  }
}
