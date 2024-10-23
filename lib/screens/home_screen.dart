import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shimmer/shimmer.dart';
import 'package:stop_finder/constants/app_constants.dart';
import 'package:stop_finder/constants/user_data.dart';
import 'package:stop_finder/place_bloc/place_bloc.dart';
import 'package:stop_finder/screens/map_screen.dart';
import 'package:stop_finder/screens/stops_bottomsheet.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  late MapController _mapController;
  late PlaceBloc _placeBloc;
  bool hasPermission = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _mapController = MapController();
    _placeBloc = BlocProvider.of<PlaceBloc>(context);
    _checkAndFetchNearbyStops();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // if (state == AppLifecycleState.resumed) {
    //   _checkAndFetchNearbyStops(); // Refresh stops when app resumes
    // }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  /// Checks and fetches nearby stops based on location permission.
  Future<void> _checkAndFetchNearbyStops() async {
    await _checkLocationPermission();
    if (hasPermission) {
      _getCurrentLocation();
    }
  }

  /// Fetches the current location using Geolocator.
  Future<void> _getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
    );
    UserData.placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
    setState(() {
      UserData.currentPosition = position;
    });
    _placeBloc.add(FetchNearbyStops(position.latitude, position.longitude)); // Fetch nearby stops
  }

  /// Recents the map to the user's current location.
  void _recenterMap() {
    _mapController.move(
      LatLng(UserData.currentPosition!.latitude, UserData.currentPosition!.longitude),
      18.0,
    );
  }

  /// Checks if location permission is granted.
  Future<void> _checkLocationPermission() async {
    PermissionStatus status = await Permission.location.status;
    if (status.isGranted) {
      hasPermission = true;
    } else if (status.isDenied) {
      await _requestLocationPermission();
    } else if (status.isPermanentlyDenied) {
      _showPermissionDeniedDialog();
    }
  }

  /// Requests location permission from the user.
  Future<void> _requestLocationPermission() async {
    PermissionStatus status = await Permission.location.request();
    if (status.isGranted) {
      hasPermission = true;
    } else if (status.isPermanentlyDenied) {
      _showPermissionDeniedDialog();
    }
  }

  /// Shows a dialog if location permission is denied.
  void _showPermissionDeniedDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(AppConstants.permissionTitle),
        content: Text(AppConstants.permissionDesc),
        actions: [
          TextButton(
            onPressed: () async {
              await openAppSettings();
              Navigator.of(context).pop();
            },
            child: Text(AppConstants.permissionSetting),
          ),
        ],
      ),
    );
  }

  // Builds a shimmer effect while loading
  Widget buildShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        color: Colors.white,
        height: double.infinity,
        width: double.infinity,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return hasPermission
        ? Scaffold(
            body: BlocBuilder<PlaceBloc, PlaceState>(
              builder: (context, state) {
                return Stack(
                  children: [
                    MapScreen(mapController: _mapController, placeBloc: _placeBloc, state: state),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: StopBottomSheet(state: state, placeBloc: _placeBloc),
                    ),
                  ],
                );
              },
            ),
          )
        : buildShimmer(); // Show shimmer if permission is not granted
  }
}
