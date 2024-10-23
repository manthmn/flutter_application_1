import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shimmer/shimmer.dart';
import 'package:stop_finder/models/nearby_stops.dart';
import 'package:stop_finder/place_bloc/place_bloc.dart';
import 'package:stop_finder/repository/place_repository.dart';
import 'package:stop_finder/screens/stops_bottomsheet.dart';

void main() {
  group('StopBottomSheet', () {
    testWidgets('shows loading shimmer when state is PlaceLoading', (WidgetTester tester) async {
      final state = PlaceLoading();

      await tester.pumpWidget(MaterialApp(
        home: StopBottomSheet(state: state, placeBloc: PlaceBloc(PlaceRepository())),
      ));

      await tester.pump();

      expect(find.byType(Shimmer), findsOneWidget);
    });

    testWidgets('shows stop list when state is StopsLoaded', (WidgetTester tester) async {
      final stops = [
        StopPoint(id: '1', stopLetter: 'A', commonName: 'Stop A', distance: 100),
        StopPoint(id: '2', stopLetter: 'B', commonName: 'Stop B', distance: 200),
      ];
      final state = StopsLoaded(stops: stops, stopVehicleMap: const {});

      await tester.pumpWidget(MaterialApp(
        home: StopBottomSheet(state: state, placeBloc: PlaceBloc(PlaceRepository())),
      ));

      await tester.pump();

      expect(find.text('Nearby Stops'), findsOneWidget);
      expect(find.text('Stop A'), findsOneWidget);
      expect(find.text('Stop B'), findsOneWidget);
    });

    testWidgets('shows error message when state is PlaceError', (WidgetTester tester) async {
      const state = PlaceError('Failed to load stops.');

      await tester.pumpWidget(MaterialApp(
        home: StopBottomSheet(state: state, placeBloc: PlaceBloc(PlaceRepository())),
      ));

      await tester.pump();

      expect(find.text('Failed to load stops.'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });
  });
}
