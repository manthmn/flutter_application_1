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
  final Map<String, List<VehicleDetails>> stopVehicleMap;

  const StopsLoaded({required this.stops, required this.stopVehicleMap});

  @override
  List<Object> get props => [stops, stopVehicleMap];
}

class BusArrivalsLoaded extends PlaceState {
  final Map<String, List<VehicleDetails>> stopVehicleMap;

  const BusArrivalsLoaded(this.stopVehicleMap);

  @override
  List<Object> get props => [stopVehicleMap];
}

class PlaceError extends PlaceState {
  final String message;

  const PlaceError(this.message);

  @override
  List<Object> get props => [message];
}
