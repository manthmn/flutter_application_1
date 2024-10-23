import 'package:equatable/equatable.dart';
import 'package:stop_finder/nearby_stops.dart';
import 'package:stop_finder/tfl_repository.dart';
import 'package:stop_finder/vehicle_details.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'place_event.dart';
part 'place_state.dart';

class PlaceBloc extends Bloc<PlaceEvent, PlaceState> {
  final TfLRepository repository;
  List<StopPoint> stops = [];
  Map<String, List<VehicleDetails>> stopVehicleMap = {};

  PlaceBloc(this.repository) : super(PlaceInitial()) {
    on<FetchNearbyStops>(_onFetchNearbyStops);
  }

  Future<void> _onFetchNearbyStops(FetchNearbyStops event, Emitter<PlaceState> emit) async {
    emit(PlaceLoading());
    try {
      stops = await repository.getNearbyStops(event.latitude, event.longitude);
      emit(StopsLoaded(stops: stops, stopVehicleMap: stopVehicleMap));
      await Future.wait(stops.map((stop) async {
        stopVehicleMap[stop.id!] = await repository.getBusArrivals(stop.id!);
      }));
      emit(StopsLoaded(stops: stops, stopVehicleMap: stopVehicleMap));
    } catch (e) {
      emit(PlaceError(e.toString()));
    }
  }
}
