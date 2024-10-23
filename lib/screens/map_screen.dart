import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:stop_finder/constants/app_constants.dart';
import 'package:stop_finder/constants/user_data.dart';
import 'package:stop_finder/models/nearby_stops.dart';
import 'package:stop_finder/place_bloc/place_bloc.dart';
import 'package:stop_finder/screens/main_marker.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({
    super.key,
    required MapController mapController,
    required PlaceBloc placeBloc,
    required dynamic state,
  })  : _mapController = mapController,
        _placeBloc = placeBloc,
        _state = state;

  final MapController _mapController;
  final PlaceBloc _placeBloc;
  final dynamic _state;

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        initialCenter: LatLng(UserData.currentPosition!.latitude, UserData.currentPosition!.longitude),
        initialZoom: 18.0,
        interactionOptions: const InteractionOptions(
          flags: InteractiveFlag.pinchZoom |
              InteractiveFlag.doubleTapZoom |
              InteractiveFlag.pinchMove |
              InteractiveFlag.drag,
          rotationThreshold: 20.0,
          rotationWinGestures: MultiFingerGesture.rotate,
          pinchZoomThreshold: 0.5,
          pinchZoomWinGestures: MultiFingerGesture.pinchZoom | MultiFingerGesture.pinchMove,
          pinchMoveThreshold: 40.0,
          pinchMoveWinGestures: MultiFingerGesture.pinchZoom | MultiFingerGesture.pinchMove,
          scrollWheelVelocity: 0.005,
        ),
        onMapReady: () {},
      ),
      children: [
        TileLayer(
          // Load map tiles
          urlTemplate: AppConstants.mapTileUrl,
        ),
        MarkerLayer(
          markers: [
            // Current location Marker
            Marker(
              width: 80.0,
              height: 80.0,
              point: LatLng(UserData.currentPosition!.latitude, UserData.currentPosition!.longitude),
              child: const MainMarker(),
            ),
            // Add markers for each stop point
            if (_state is StopsLoaded || _state is StopsVehicleLoaded || _state is SelectedStopLoaded)
              ...((_state is StopsLoaded
                      ? _state.stops
                      : _state is StopsVehicleLoaded
                          ? _state.stops
                          : (_state as SelectedStopLoaded).stops)
                  .asMap()
                  .entries
                  .where((entry) => entry.value.lat != null && entry.value.lon != null)
                  .map((entry) {
                int index = entry.key;
                StopPoint stop = entry.value;
                double pointerSize = ((_state is StopsLoaded || _state is StopsVehicleLoaded)
                            ? null
                            : (_state as SelectedStopLoaded).selectedStopIndex) ==
                        index
                    ? 36
                    : 28;

                return Marker(
                  width: 80.0,
                  height: 80.0,
                  point: LatLng(stop.lat!, stop.lon!),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      InkWell(
                        // Handle marker tap to fetch selected stop details
                        onTap: () {
                          _placeBloc.add(FetchSelectedStopDetails(index));
                        },
                        child: Container(
                            height: pointerSize,
                            width: pointerSize,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: AppConstants.stopColor,
                              shape: BoxShape.circle,
                            ),
                            child: stop.stopLetter != null
                                ? Text(
                                    stop.stopLetter!,
                                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                                  )
                                : const Icon(Icons.directions_bus, color: Colors.white, size: 14)),
                      ),
                      const SizedBox(height: 2),
                      Container(
                        height: 6,
                        width: 6,
                        decoration: const BoxDecoration(color: Colors.black, shape: BoxShape.circle),
                      ),
                    ],
                  ),
                );
              }).toList()),
          ],
        ),
      ],
    );
  }
}
