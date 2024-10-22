class NearbyStops {
  NearbyStops({
    required this.type,
    required this.centrePoint,
    required this.stopPoints,
    required this.pageSize,
    required this.total,
    required this.page,
  });

  final String? type;
  final List<double> centrePoint;
  final List<StopPoint> stopPoints;
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

  Map<String, dynamic> toJson() => {
        "\u0024type": type,
        "centrePoint": centrePoint.map((x) => x).toList(),
        "stopPoints": stopPoints.map((x) => x?.toJson()).toList(),
        "pageSize": pageSize,
        "total": total,
        "page": page,
      };
}

class StopPoint {
  StopPoint({
    required this.type,
    required this.naptanId,
    required this.indicator,
    required this.stopLetter,
    required this.modes,
    required this.icsCode,
    required this.stopType,
    required this.lines,
    required this.lineGroup,
    required this.lineModeGroups,
    required this.status,
    required this.id,
    required this.commonName,
    required this.distance,
    required this.placeType,
    required this.additionalProperties,
    required this.children,
    required this.lat,
    required this.lon,
  });

  final String? type;
  final String? naptanId;
  final String? indicator;
  final String? stopLetter;
  final List<String> modes;
  final String? icsCode;
  final String? stopType;
  final List<Line> lines;
  final List<LineGroup> lineGroup;
  final List<LineModeGroup> lineModeGroups;
  final bool? status;
  final String? id;
  final String? commonName;
  final double? distance;
  final String? placeType;
  final List<AdditionalProperty> additionalProperties;
  final List<dynamic> children;
  final double? lat;
  final double? lon;

  factory StopPoint.fromJson(Map<String, dynamic> json) {
    return StopPoint(
      type: json["\u0024type"],
      naptanId: json["naptanId"],
      indicator: json["indicator"],
      stopLetter: json["stopLetter"],
      modes: json["modes"] == null ? [] : List<String>.from(json["modes"]!.map((x) => x)),
      icsCode: json["icsCode"],
      stopType: json["stopType"],
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
    );
  }

  Map<String, dynamic> toJson() => {
        "\u0024type": type,
        "naptanId": naptanId,
        "indicator": indicator,
        "stopLetter": stopLetter,
        "modes": modes.map((x) => x).toList(),
        "icsCode": icsCode,
        "stopType": stopType,
        "lines": lines.map((x) => x?.toJson()).toList(),
        "lineGroup": lineGroup.map((x) => x?.toJson()).toList(),
        "lineModeGroups": lineModeGroups.map((x) => x?.toJson()).toList(),
        "status": status,
        "id": id,
        "commonName": commonName,
        "distance": distance,
        "placeType": placeType,
        "additionalProperties": additionalProperties.map((x) => x?.toJson()).toList(),
        "children": children.map((x) => x).toList(),
        "lat": lat,
        "lon": lon,
      };
}

class AdditionalProperty {
  AdditionalProperty({
    required this.type,
    required this.category,
    required this.key,
    required this.sourceSystemKey,
    required this.value,
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

  Map<String, dynamic> toJson() => {
        "\u0024type": type,
        "category": category,
        "key": key,
        "sourceSystemKey": sourceSystemKey,
        "value": value,
      };
}

class LineGroup {
  LineGroup({
    required this.type,
    required this.naptanIdReference,
    required this.lineIdentifier,
  });

  final String? type;
  final String? naptanIdReference;
  final List<String> lineIdentifier;

  factory LineGroup.fromJson(Map<String, dynamic> json) {
    return LineGroup(
      type: json["\u0024type"],
      naptanIdReference: json["naptanIdReference"],
      lineIdentifier: json["lineIdentifier"] == null ? [] : List<String>.from(json["lineIdentifier"]!.map((x) => x)),
    );
  }

  Map<String, dynamic> toJson() => {
        "\u0024type": type,
        "naptanIdReference": naptanIdReference,
        "lineIdentifier": lineIdentifier.map((x) => x).toList(),
      };
}

class LineModeGroup {
  LineModeGroup({
    required this.type,
    required this.modeName,
    required this.lineIdentifier,
  });

  final String? type;
  final String? modeName;
  final List<String> lineIdentifier;

  factory LineModeGroup.fromJson(Map<String, dynamic> json) {
    return LineModeGroup(
      type: json["\u0024type"],
      modeName: json["modeName"],
      lineIdentifier: json["lineIdentifier"] == null ? [] : List<String>.from(json["lineIdentifier"]!.map((x) => x)),
    );
  }

  Map<String, dynamic> toJson() => {
        "\u0024type": type,
        "modeName": modeName,
        "lineIdentifier": lineIdentifier.map((x) => x).toList(),
      };
}

class Line {
  Line({
    required this.type,
    required this.id,
    required this.name,
    required this.uri,
    required this.lineType,
    required this.crowding,
    required this.routeType,
    required this.status,
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

  Map<String, dynamic> toJson() => {
        "\u0024type": type,
        "id": id,
        "name": name,
        "uri": uri,
        "type": lineType,
        "crowding": crowding?.toJson(),
        "routeType": routeType,
        "status": status,
      };
}

class Crowding {
  Crowding({
    required this.type,
  });

  final String? type;

  factory Crowding.fromJson(Map<String, dynamic> json) {
    return Crowding(
      type: json["\u0024type"],
    );
  }

  Map<String, dynamic> toJson() => {
        "\u0024type": type,
      };
}
