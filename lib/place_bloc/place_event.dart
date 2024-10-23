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

class FetchBatchStopDetails extends PlaceEvent {} // Fetch details in batch for stops

class FetchSelectedStopDetails extends PlaceEvent {
  final int stopIndex; // Index of the selected stop

  const FetchSelectedStopDetails(this.stopIndex);

  @override
  List<Object> get props => [stopIndex];
}

class BackToNearbyStops extends PlaceEvent {} // Event to go back to nearby stops

class StartContinuousUpdates extends PlaceEvent {} // Start continuous location updates

class StopContinuousUpdates extends PlaceEvent {} // Stop continuous location updates
