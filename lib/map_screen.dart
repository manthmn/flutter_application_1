import 'package:flutter/material.dart';
import 'package:flutter_application_1/bus_arrival.dart';
import 'package:flutter_application_1/nearby_stops.dart';
import 'package:flutter_application_1/place_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:permission_handler/permission_handler.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  Position? _currentPosition;
  late MapController _mapController;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _requestLocationPermission();
  }

  Future<void> _requestLocationPermission() async {
    if (await Permission.location.request().isGranted) {
      _getCurrentLocation();
    }
  }

  void _getCurrentLocation() async {
    Position position =
        await Geolocator.getCurrentPosition(locationSettings: LocationSettings(accuracy: LocationAccuracy.high));
    setState(() {
      _currentPosition = position;
    });
    BlocProvider.of<PlaceBloc>(context).add(FetchNearbyStops(position.latitude, position.longitude));
  }

  void _recenterMap() {
    _mapController.move(
      LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
      18.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _currentPosition == null
              ? const Center(child: CircularProgressIndicator())
              : BlocBuilder<PlaceBloc, PlaceState>(
                  builder: (context, state) {
                    return _buildMap(state);
                  },
                ),
          // Floating Search Bar
          Positioned(
            top: 48,
            left: 15,
            right: 15,
            child: Material(
              elevation: 5.0,
              borderRadius: BorderRadius.circular(8.0),
              child: TextField(
                onTap: () {
                  // Add your search functionality here
                },
                readOnly: true,
                decoration: const InputDecoration(
                  hintText: 'Search here...',
                  prefixIcon: Icon(Icons.search),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 15),
                ),
              ),
            ),
          ),
          // Category Buttons
          Positioned(
            top: 108,
            left: 0,
            right: 0,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildCategoryButton(Icons.restaurant, 'Restaurants'),
                  _buildCategoryButton(Icons.hotel, 'Hotels'),
                  _buildCategoryButton(Icons.local_cafe, 'Coffee'),
                  _buildCategoryButton(Icons.local_gas_station, 'Petrol'),
                ],
              ),
            ),
          ),
          // Bottom Sheet
          Align(
            alignment: Alignment.bottomCenter,
            child: BlocBuilder<PlaceBloc, PlaceState>(
              builder: (context, state) {
                if (state is PlaceLoading) {
                  return const CircularProgressIndicator();
                } else if (state is StopsLoaded) {
                  return _buildBottomSheet(state.stops);
                } else if (state is BusArrivalsLoaded) {
                  return _buildBusArrivalsSheet(state.busArrivals);
                } else if (state is PlaceError) {
                  return Center(child: Text(state.message));
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _recenterMap,
        child: const Icon(Icons.my_location),
      ),
    );
  }

  Widget _buildMap(PlaceState state) {
    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        initialCenter: LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
        initialZoom: 17.0,
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
        onMapReady: () {
          print("Map is ready!");
        },
      ),
      children: [
        TileLayer(
          urlTemplate: "https://{s}.basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}.png",
          subdomains: ['a', 'b', 'c'],
        ),
        MarkerLayer(
          markers: [
            Marker(
              width: 80.0,
              height: 80.0,
              point: LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
              child: const Icon(
                Icons.location_on,
                color: Colors.red,
                size: 40,
              ),
            ),
            // Add markers for each stop point
            if (state is StopsLoaded)
              ...state.stops.where((stop) => stop.lat != null && stop.lon != null).map((stop) {
                return Marker(
                  width: 80.0,
                  height: 80.0,
                  point: LatLng(stop.lat!, stop.lon!),
                  child: const Icon(
                    Icons.location_on,
                    color: Colors.blue,
                    size: 40,
                  ),
                );
              }).toList(),
          ],
        ),
      ],
    );
  }

  Widget _buildCategoryButton(IconData icon, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: ElevatedButton.icon(
        onPressed: () {
          // Add category filtering functionality here
        },
        icon: Icon(icon),
        label: Text(label),
      ),
    );
  }

  Widget _buildBottomSheet(List<StopPoint> stops) {
    return DraggableScrollableSheet(
      initialChildSize: 0.4,
      minChildSize: 0.2,
      maxChildSize: 0.8,
      builder: (BuildContext context, ScrollController scrollController) {
        return Material(
          elevation: 10.0,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: 50,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                Text(
                  'Nearby Stops',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    controller: scrollController,
                    itemCount: stops.length,
                    itemBuilder: (context, index) {
                      // Extract relevant data from StopPoint
                      StopPoint stop = stops[index];
                      String walkingDistance = "${stop.distance!.toStringAsFixed(0)}m Walk"; // Adjust as needed
                      List<String> busRoutes = stop.lines.map((line) => line.name!).toList(); // Extract line names

                      return Card(
                        elevation: 2,
                        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                stop.commonName ?? "Unknown Stop",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(walkingDistance),
                              SizedBox(height: 5),
                              Text(
                                busRoutes.join(", "),
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBusArrivalsSheet(List<BusArrival> busArrivals) {
    return DraggableScrollableSheet(
      initialChildSize: 0.3,
      minChildSize: 0.2,
      maxChildSize: 0.8,
      builder: (BuildContext context, ScrollController scrollController) {
        return Material(
          elevation: 10.0,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: 50,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                Text(
                  'Bus Arrivals',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    controller: scrollController,
                    itemCount: busArrivals.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text('${busArrivals[index].lineName} to ${busArrivals[index].destinationName}'),
                        subtitle: Text('Expected Arrival: ${busArrivals[index].expectedArrival}'),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
