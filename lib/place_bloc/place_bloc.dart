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
  Timer? _timerBatch;
  Timer? _timer;
  bool _isContinuousUpdatesStarted = false;
  bool _isContinuousUpdatesStartedSelected = false;

  PlaceBloc(this.placeRepository) : super(PlaceInitial()) {
    // Event handlers
    on<FetchNearbyStops>(_onFetchNearbyStops);
    on<FetchStops>(_onFetchStops);
    on<FetchBatchStopDetails>(_onFetchBatchStopDetails);
    on<BackToNearbyStops>(_onBackToNearbyStops);
    on<StartContinuousUpdates>(_onStartContinuousUpdates);
    on<StopContinuousUpdates>(_onStopContinuousUpdates);
    on<FetchSelectedStopDetails>(_onFetchSelectedStopDetails);
    on<StartContinuousUpdatesSelected>(_onStartContinuousUpdatesSelected);
    on<StopContinuousUpdatesSelected>(_onStopContinuousUpdatesSelected);
    on<FetchSingleStop>(_onFetchSingleStop);
  }

  Future<void> _onFetchNearbyStops(FetchNearbyStops event, Emitter<PlaceState> emit) async {
    emit(PlaceLoading());
    try {
      stops.clear();
      // Fetch nearby stops based on coordinates
      stops = await placeRepository.getNearbyStops(event.latitude, event.longitude);
      stops = stops.where((stop) => (stop.lines ?? []).isNotEmpty).toList();
      add(FetchStops());
    } catch (e) {
      emit(PlaceError(e.toString()));
    }
  }

  Future<void> _onFetchStops(FetchStops event, Emitter<PlaceState> emit) async {
    try {
      // Fetch vehicle details for the selected stop
      add(StopContinuousUpdates());
      add(FetchBatchStopDetails());
      if (!_isContinuousUpdatesStarted) {
        _isContinuousUpdatesStarted = true;
        add(StartContinuousUpdates());
      }
    } catch (e) {
      emit(PlaceError(e.toString()));
    }
  }

  Future<void> _onStartContinuousUpdates(StartContinuousUpdates event, Emitter<PlaceState> emit) async {
    // Set timer to fetch batch stop details periodically
    _timerBatch = Timer.periodic(Duration(seconds: AppConstants.refreshTime), (timer) {
      add(FetchBatchStopDetails());
    });
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

  Future<void> _onStopContinuousUpdates(StopContinuousUpdates event, Emitter<PlaceState> emit) async {
    _timerBatch?.cancel();
    _timerBatch = null;
    _isContinuousUpdatesStarted = false;
    emit(SelectedStopVehicleLoaded(stops: stops, stopVehicleMap: stopVehicleMap, selectedStopIndex: 2));
  }

  Future<void> _onFetchSelectedStopDetails(FetchSelectedStopDetails event, Emitter<PlaceState> emit) async {
    try {
      // Fetch vehicle details for the selected stop
      add(StopContinuousUpdatesSelected());
      add(FetchSingleStop(event.stopIndex));
      if (!_isContinuousUpdatesStartedSelected) {
        _isContinuousUpdatesStartedSelected = true;
        add(StartContinuousUpdatesSelected(event.stopIndex));
      }
    } catch (e) {
      emit(PlaceError(e.toString()));
    }
  }

  Future<void> _onStartContinuousUpdatesSelected(StartContinuousUpdatesSelected event, Emitter<PlaceState> emit) async {
    // Set timer to fetch batch stop details periodically
    _timer = Timer.periodic(Duration(seconds: AppConstants.refreshTime), (timer) {
      add(FetchSingleStop(event.stopIndex));
    });
  }

  Future<void> _onFetchSingleStop(FetchSingleStop event, Emitter<PlaceState> emit) async {
    try {
      // Fetch vehicle details for the selected stop
      emit(SelectedStopLoaded(stops: stops, stopVehicleMap: stopVehicleMap, selectedStopIndex: event.stopIndex));
      stopVehicleMap[stops[event.stopIndex].id!] = await placeRepository.getBusArrivals(stops[event.stopIndex].id!);
      emit(SelectedStopVehicleLoaded(stops: stops, stopVehicleMap: stopVehicleMap, selectedStopIndex: event.stopIndex));
    } catch (e) {
      emit(PlaceError(e.toString()));
    }
  }

  Future<void> _onStopContinuousUpdatesSelected(StopContinuousUpdatesSelected event, Emitter<PlaceState> emit) async {
    _timer?.cancel();
    _timer = null;
    _isContinuousUpdatesStartedSelected = false;
  }

  Future<void> _onBackToNearbyStops(BackToNearbyStops event, Emitter<PlaceState> emit) async {
    try {
      emit(StopsLoaded(stops: stops, stopVehicleMap: stopVehicleMap)); // Emit nearby stops
    } catch (e) {
      emit(PlaceError(e.toString()));
    }
  }
}
