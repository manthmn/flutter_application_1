import 'package:flutter/material.dart';

class AppConstants {
  static int refreshTime = 60;
  static String mapTileUrl = "https://{s}.basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}.png";
  static String permissionTitle = "Location Permission Required";
  static String permissionDesc =
      "This app needs location access to function. Please grant location permission in settings.";
  static String permissionSetting = "Open Settings";
  static Color stopColor = const Color.fromARGB(255, 180, 22, 22);
  static Color lineNameColor = const Color.fromARGB(255, 241, 222, 100);
  static Color locationTextColor = const Color.fromARGB(255, 10, 30, 46);
  static Color mainMarkerColor = Color.fromARGB(255, 13, 69, 115);
}
