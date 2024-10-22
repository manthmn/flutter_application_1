import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/place_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  // Set the system UI overlay style before running the app
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle.light.copyWith(
      statusBarColor: Colors.transparent, // Make status bar transparent
      statusBarIconBrightness: Brightness.dark, // Make icons light
    ),
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Map App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BlocProvider(
        create: (context) => PlaceBloc()..add(FetchPlaces()),
        child: MapScreen(),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  Position? _currentPosition;

  @override
  void initState() {
    super.initState();
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _currentPosition == null
              ? const Center(child: CircularProgressIndicator())
              : FlutterMap(
                  options: MapOptions(
                    crs: Epsg3857(), // Coordinate reference system
                    initialCenter: LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
                    initialZoom: 14.0,
                    onMapReady: () {
                      print("Map is ready!");
                    },
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                      // subdomains: [],
                    ),
                    MarkerLayer(
                      markers: [
                        Marker(
                          width: 80.0,
                          height: 80.0,
                          point: LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
                          child: const Icon(Icons.location_on, color: Colors.red, size: 40),
                        ),
                      ],
                    ),
                  ],
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
                } else if (state is PlaceLoaded) {
                  return _buildBottomSheet(state.places);
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _getCurrentLocation,
        child: const Icon(Icons.my_location),
      ),
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

  Widget _buildBottomSheet(List<String> places) {
    return DraggableScrollableSheet(
      initialChildSize: 0.3, // Initial size of the sheet
      minChildSize: 0.2, // Minimum size of the sheet when dragged down
      maxChildSize: 0.8, // Maximum size of the sheet when fully dragged up
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
                  'Latest in Vyalikaval Society',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    controller: scrollController, // Attach the scroll controller
                    scrollDirection: Axis.vertical,
                    itemCount: places.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Container(
                              width: 100,
                              height: 100,
                              color: Colors.grey[300],
                              child: Center(child: Text(places[index])),
                            ),
                            SizedBox(height: 5),
                            Text('Price for tonight'),
                          ],
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
}
