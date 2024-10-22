class BusArrival {
  final String lineName;
  final String destinationName;
  final String expectedArrival;

  BusArrival({required this.lineName, required this.destinationName, required this.expectedArrival});

  factory BusArrival.fromJson(Map<String, dynamic> json) {
    return BusArrival(
      lineName: json['lineName'],
      destinationName: json['destinationName'],
      expectedArrival: json['expectedArrival'],
    );
  }
}
