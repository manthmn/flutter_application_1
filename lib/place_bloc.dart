import 'package:equatable/equatable.dart';
import 'package:flutter_application_1/bus_arrival.dart';
import 'package:flutter_application_1/nearby_stops.dart';
import 'package:flutter_application_1/tfl_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'place_event.dart';
part 'place_state.dart';

class PlaceBloc extends Bloc<PlaceEvent, PlaceState> {
  final TfLRepository repository;

  PlaceBloc(this.repository) : super(PlaceInitial()) {
    on<FetchNearbyStops>(_onFetchNearbyStops);
    on<FetchBusArrivals>(_onFetchBusArrivals);
  }

  Future<void> _onFetchNearbyStops(FetchNearbyStops event, Emitter<PlaceState> emit) async {
    emit(PlaceLoading());
    try {
      final stops = await repository.getNearbyStops(event.latitude, event.longitude);
      emit(StopsLoaded(stops));
    } catch (e) {
      emit(PlaceError(e.toString()));
    }
  }

  Future<void> _onFetchBusArrivals(FetchBusArrivals event, Emitter<PlaceState> emit) async {
    emit(PlaceLoading());
    try {
      final busArrivals = await repository.getBusArrivals(event.stopId);
      emit(BusArrivalsLoaded(busArrivals));
    } catch (e) {
      emit(PlaceError(e.toString()));
    }
  }
}
