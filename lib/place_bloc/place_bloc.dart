import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stop_finder/constants/app_constants.dart';
import 'package:stop_finder/models/nearby_stops.dart';
import 'package:stop_finder/models/vehicle_details.dart';
import 'package:stop_finder/repository/place_repository.dart';

part 'place_event.dart';
part 'place_state.dart';

class PlaceBloc extends Bloc<PlaceEvent, PlaceState> {
  final PlaceRepository placeRepository;
  List<StopPoint> stops = []; // List of nearby stops
  Map<String, List<VehicleDetails>> stopVehicleMap = {}; // Mapping of stops to vehicle details
  Timer? _timer;
  bool _isContinuousUpdatesStarted = false;

  PlaceBloc(this.placeRepository) : super(PlaceInitial()) {
    // Event handlers
    on<FetchNearbyStops>(_onFetchNearbyStops);
    on<FetchBatchStopDetails>(_onFetchBatchStopDetails);
    on<FetchSelectedStopDetails>(_onFetchSelectedStopDetails);
    on<BackToNearbyStops>(_onBackToNearbyStops);
    on<StartContinuousUpdates>(_onStartContinuousUpdates);
    on<StopContinuousUpdates>(_onStopContinuousUpdates);
  }

  Future<void> _onFetchNearbyStops(FetchNearbyStops event, Emitter<PlaceState> emit) async {
    emit(PlaceLoading());
    try {
      stops.clear();
      // Fetch nearby stops based on coordinates
      stops = await placeRepository.getNearbyStops(event.latitude, event.longitude);
      stops = stops.where((stop) => (stop.lines ?? []).isNotEmpty).toList();
      if (!_isContinuousUpdatesStarted) {
        _isContinuousUpdatesStarted = true;
        add(StartContinuousUpdates());
      }
      add(FetchBatchStopDetails()); // Fetch for 1st stop
    } catch (e) {
      emit(PlaceError(e.toString()));
    }
  }

  Future<void> _onFetchBatchStopDetails(FetchBatchStopDetails event, Emitter<PlaceState> emit) async {
    try {
      emit(StopsLoaded(stops: stops, stopVehicleMap: stopVehicleMap));
      await Future.wait(stops.map((stop) async {
        try {
          stopVehicleMap[stop.id!] = await placeRepository.getBusArrivals(stop.id!);
        } catch (e) {
          stopVehicleMap[stop.id!] = []; // Handle individual stop fetch failure
        }
      }));
      emit(StopsVehicleLoaded(stops: stops, stopVehicleMap: stopVehicleMap));
    } catch (e) {
      emit(PlaceError(e.toString()));
    }
  }

  Future<void> _onStartContinuousUpdates(StartContinuousUpdates event, Emitter<PlaceState> emit) async {
    // Set timer to fetch batch stop details periodically
    _timer = Timer.periodic(Duration(seconds: AppConstants.refreshTime), (timer) {
      add(FetchBatchStopDetails());
    });
  }

  Future<void> _onStopContinuousUpdates(StopContinuousUpdates event, Emitter<PlaceState> emit) async {
    _timer?.cancel();
    _timer = null;
  }

  Future<void> _onFetchSelectedStopDetails(FetchSelectedStopDetails event, Emitter<PlaceState> emit) async {
    try {
      // Fetch vehicle details for the selected stop
      stopVehicleMap[stops[event.stopIndex].id!] = await placeRepository.getBusArrivals(stops[event.stopIndex].id!);
      emit(SelectedStopLoaded(stops: stops, stopVehicleMap: stopVehicleMap, selectedStopIndex: event.stopIndex));
    } catch (e) {
      emit(PlaceError(e.toString()));
    }
  }

  Future<void> _onBackToNearbyStops(BackToNearbyStops event, Emitter<PlaceState> emit) async {
    try {
      emit(StopsLoaded(stops: stops, stopVehicleMap: stopVehicleMap)); // Emit nearby stops
    } catch (e) {
      emit(PlaceError(e.toString()));
    }
  }
}
