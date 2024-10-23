part of 'place_bloc.dart';

abstract class PlaceState extends Equatable {
  const PlaceState();

  @override
  List<Object> get props => [];
}

class PlaceInitial extends PlaceState {} // Initial state

class PlaceLoading extends PlaceState {} // Loading state

class StopsLoaded extends PlaceState {
  final List<StopPoint> stops; // List of nearby stops
  final Map<String, List<VehicleDetails>> stopVehicleMap; // Vehicle details by stop

  const StopsLoaded({required this.stops, required this.stopVehicleMap});

  @override
  List<Object> get props => [stops, stopVehicleMap];
}

class StopsVehicleLoaded extends PlaceState {
  final List<StopPoint> stops;
  final Map<String, List<VehicleDetails>> stopVehicleMap;

  const StopsVehicleLoaded({required this.stops, required this.stopVehicleMap});

  @override
  List<Object> get props => [stops, stopVehicleMap];
}

class SelectedStopLoaded extends PlaceState {
  final List<StopPoint> stops;
  final Map<String, List<VehicleDetails>> stopVehicleMap;
  final int selectedStopIndex; // Index of the selected stop

  const SelectedStopLoaded({required this.stops, required this.stopVehicleMap, required this.selectedStopIndex});

  @override
  List<Object> get props => [stops, stopVehicleMap, selectedStopIndex];
}

class PlaceError extends PlaceState {
  final String message; // Error message

  const PlaceError(this.message);

  @override
  List<Object> get props => [message];
}
