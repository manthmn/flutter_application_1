part of 'place_bloc.dart';

abstract class PlaceEvent extends Equatable {
  const PlaceEvent();

  @override
  List<Object> get props => [];
}

class FetchNearbyStops extends PlaceEvent {
  final double latitude;
  final double longitude;

  const FetchNearbyStops(this.latitude, this.longitude);

  @override
  List<Object> get props => [latitude, longitude];
}

class FetchBusArrivals extends PlaceEvent {
  final String stopId;

  const FetchBusArrivals(this.stopId);

  @override
  List<Object> get props => [stopId];
}
