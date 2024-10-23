import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stop_finder/map_screen.dart';
import 'package:stop_finder/place_bloc.dart';
import 'package:stop_finder/tfl_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle.light.copyWith(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Map App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BlocProvider(
        create: (context) => PlaceBloc(TfLRepository()), // Example coordinates for London
        child: const MapScreen(),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
