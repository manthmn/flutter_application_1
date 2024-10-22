part of 'place_bloc.dart';

abstract class PlaceState extends Equatable {
  const PlaceState();

  @override
  List<Object> get props => [];
}

class PlaceInitial extends PlaceState {}

class PlaceLoading extends PlaceState {}

class StopsLoaded extends PlaceState {
  final List<StopPoint> stops;

  const StopsLoaded(this.stops);

  @override
  List<Object> get props => [stops];
}

class BusArrivalsLoaded extends PlaceState {
  final List<BusArrival> busArrivals;

  const BusArrivalsLoaded(this.busArrivals);

  @override
  List<Object> get props => [busArrivals];
}

class PlaceError extends PlaceState {
  final String message;

  const PlaceError(this.message);

  @override
  List<Object> get props => [message];
}
