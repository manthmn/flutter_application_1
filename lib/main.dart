import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/map_screen.dart';
import 'package:flutter_application_1/place_bloc.dart';
import 'package:flutter_application_1/tfl_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle.light.copyWith(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
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
        create: (context) =>
            PlaceBloc(TfLRepository())..add(FetchNearbyStops(51.5074, -0.1278)), // Example coordinates for London
        child: MapScreen(),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
