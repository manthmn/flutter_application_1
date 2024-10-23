import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shimmer/shimmer.dart';
import 'package:stop_finder/current_location_marker.dart';
import 'package:stop_finder/nearby_stops.dart';
import 'package:stop_finder/place_bloc.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  Position? _currentPosition;
  late MapController _mapController;
  StopPoint? _selectedStop;

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
        await Geolocator.getCurrentPosition(locationSettings: const LocationSettings(accuracy: LocationAccuracy.high));
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

  Widget buildShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView.builder(
        itemCount: 6, // Number of shimmer items to show
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(width: 20, height: 20, color: Colors.white),
                      SizedBox(width: 8),
                      Container(width: 50, height: 20, color: Colors.white),
                    ],
                  ),
                  SizedBox(height: 5),
                  Container(width: double.infinity, height: 20, color: Colors.white),
                  SizedBox(height: 5),
                  Container(width: 100, height: 20, color: Colors.white),
                  SizedBox(height: 5),
                  Container(width: 150, height: 20, color: Colors.white),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Container(width: 30, height: 20, color: Colors.white),
                      SizedBox(width: 5),
                      Container(width: 60, height: 20, color: Colors.white),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
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
                  hintText: 'know your loc? type here...',
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
                return _buildBottomSheet(state: state);
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
          subdomains: const ['a', 'b', 'c'],
        ),
        MarkerLayer(
          markers: [
            Marker(
              width: 80.0,
              height: 80.0,
              point: LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
              child: CurrentLocationMarker(),
            ),
            // Add markers for each stop point
            if (state is StopsLoaded)
              ...state.stops.where((stop) => stop.lat != null && stop.lon != null).map((stop) {
                return Marker(
                  width: 80.0,
                  height: 80.0,
                  point: LatLng(stop.lat!, stop.lon!),
                  child: Stack(
                    children: [
                      const Icon(
                        Icons.location_on,
                        color: Colors.blue,
                        size: 40,
                      ),
                      Positioned(top: 2, child: Text(stop.stopLetter!))
                    ],
                  ),
                );
              }).toList(),
          ],
        ),
      ],
    );
  }

//   Widget createCustomMarkerChild(String stopLetter) {
//   return Stack(
//     alignment: Alignment.topCenter,
//     children: [
//       // Pointer (triangle)
//       Positioned(
//         bottom: 0, // Position the triangle below the circle
//         child: CustomPaint(
//           size: Size(20, 20), // Size of the triangle
//           painter: TrianglePainter(),
//         ),
//       ),
//       // Circle for the marker
//       Container(
//         width: 50, // Adjust circle size as needed
//         height: 50, // Adjust circle size as needed
//         decoration: BoxDecoration(
//           color: Colors.red,
//           shape: BoxShape.circle,
//         ),
//         alignment: Alignment.center,
//         child: Text(
//           stopLetter,
//           style: const TextStyle(
//             color: Colors.white,
//             fontWeight: FontWeight.bold,
//             fontSize: 20, // Adjust font size as needed
//           ),
//         ),
//       ),
//     ],
//   );
// }

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

  Widget _buildBottomSheet({required PlaceState state}) {
    return DraggableScrollableSheet(
      initialChildSize: 0.4,
      minChildSize: 0.2,
      maxChildSize: 0.8,
      builder: (BuildContext context, ScrollController scrollController) {
        return Material(
          elevation: 10.0,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          child: Container(
            decoration: const BoxDecoration(
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
                const Text(
                  'Nearby Stops',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Expanded(
                  child: Builder(
                    builder: (context) {
                      if (state is PlaceLoading) {
                        return buildShimmer();
                      } else if (state is StopsLoaded) {
                        // Check if a stop is selected
                        if (_selectedStop != null) {
                          return _buildStopDetailView(_selectedStop!);
                        } else {
                          return ListView.builder(
                            controller: scrollController,
                            itemCount: state.stops.length,
                            itemBuilder: (context, index) {
                              StopPoint stop = state.stops[index];
                              String walkingDistance = "${stop.distance!.toStringAsFixed(0)}m Walk";
                              List<String> busRoutes = stop.lines.map((line) => line.name!).toList();
                              Map<String, List<int>> lineArrivalTimes = {};
                              stop.lines.forEach((line) {
                                List<int> arrivalTimes =
                                    state.stopVehicleMap[line.id]?.map((vehicle) => vehicle.timeToStation!).toList() ??
                                        [];
                                lineArrivalTimes[line.name!] = arrivalTimes;
                              });

                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedStop = stop; // Set the selected stop
                                  });
                                },
                                child: Card(
                                  margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(Icons.directions_bus),
                                            SizedBox(width: 8),
                                            Text(stop.commonName!),
                                          ],
                                        ),
                                        SizedBox(height: 5),
                                        Text('Walking Distance: $walkingDistance'),
                                        SizedBox(height: 5),
                                        Text('Bus Routes: ${busRoutes.join(', ')}'),
                                        SizedBox(height: 5),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: lineArrivalTimes.entries.map((entry) {
                                            String line = entry.key;
                                            List<int> times = entry.value;
                                            String arrivalTimes = times.map((time) {
                                              int minutes = (time / 60).floor();
                                              return '$minutes min';
                                            }).join(', ');
                                            return Text('$line: $arrivalTimes');
                                          }).toList(),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        }
                      } else if (state is PlaceError) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(state.message),
                              SizedBox(height: 8),
                              ElevatedButton(
                                onPressed: _getCurrentLocation,
                                child: Text('Retry'),
                              ),
                            ],
                          ),
                        );
                      }
                      return const SizedBox.shrink();
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

  Widget _buildStopDetailView(StopPoint stop) {
    return Column(
      children: [
        // Back Arrow Button
        IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            setState(() {
              _selectedStop = null; // Clear the selected stop to go back to the list
            });
          },
        ),
        Text(
          stop.commonName!,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        Text("Walking Distance: ${stop.distance!.toStringAsFixed(0)}m"),
        SizedBox(height: 10),
        // Display other details as needed
        // For example, show bus routes or arrival times:
        Text('Bus Routes: ${stop.lines.map((line) => line.name!).join(', ')}'),
        // Add more detailed info about the stop here
      ],
    );
  }
}
