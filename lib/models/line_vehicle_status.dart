class LineVehicleStatus {
  LineVehicleStatus({
    required this.lineId,
    required this.lineName,
    required this.destinationName,
    required this.timeToStationString,
    required this.timeToStationList,
  });

  String? lineId;
  String? lineName;
  String? destinationName;
  String? timeToStationString;
  List<int> timeToStationList;

  factory LineVehicleStatus.fromJson(Map<String, dynamic> json) {
    return LineVehicleStatus(
      lineId: json["lineId"],
      lineName: json["lineName"],
      destinationName: json["destinationName"],
      timeToStationString: json["timeToStationString"],
      timeToStationList:
          json["timeToStationList"] == null ? [] : List<int>.from(json["timeToStationList"]!.map((x) => x)),
    );
  }

  Map<String, dynamic> toJson() => {
        "lineId": lineId,
        "lineName": lineName,
        "destinationName": destinationName,
        "timeToStationString": timeToStationString,
        "timeToStationList": timeToStationList.map((x) => x).toList(),
      };
}
