import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Events
abstract class PlaceEvent extends Equatable {
  const PlaceEvent();

  @override
  List<Object> get props => [];
}

class FetchPlaces extends PlaceEvent {}

/// States
abstract class PlaceState extends Equatable {
  const PlaceState();

  @override
  List<Object> get props => [];
}

class PlaceInitial extends PlaceState {}

class PlaceLoading extends PlaceState {}

class PlaceLoaded extends PlaceState {
  final List<String> places;

  const PlaceLoaded(this.places);

  @override
  List<Object> get props => [places];
}

/// Bloc
class PlaceBloc extends Bloc<PlaceEvent, PlaceState> {
  PlaceBloc() : super(PlaceInitial()) {
    on<FetchPlaces>(_onFetchPlaces);
  }

  Future<void> _onFetchPlaces(FetchPlaces event, Emitter<PlaceState> emit) async {
    emit(PlaceLoading());
    await Future.delayed(Duration(seconds: 2)); // Simulating network call
    emit(PlaceLoaded(['Place 1', 'Place 2', 'Place 3'])); // Simulated data
  }
}
