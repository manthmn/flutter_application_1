// import 'package:flutter/material.dart';
// import 'package:flutter_application_1/nearby_stops.dart';
// import 'package:flutter_application_1/place_bloc.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// class BusStopCard extends StatelessWidget {
//   final StopPoint stop;

//   const BusStopCard({Key? key, required this.stop}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     // Mocked data for bus routes and distance
//     final List<String> busRoutes = stop.routes; // Assuming routes is a List<String>
//     final double walkingDistance = stop.walkingDistance; // Assuming walkingDistance is a double

//     return Card(
//       margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
//       elevation: 4.0,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               stop.commonName ?? 'Unknown Stop',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 8.0),
//             Text('Walking Distance: ${walkingDistance.toStringAsFixed(1)} m'),
//             const SizedBox(height: 8.0),
//             Text(
//               'Bus Routes: ${busRoutes.join(', ')}',
//               style: TextStyle(color: Colors.grey[600]),
//             ),
//             const SizedBox(height: 8.0),
//             ElevatedButton(
//               onPressed: () {
//                 // Add action for navigating to bus arrivals
//                 BlocProvider.of<PlaceBloc>(context).add(FetchBusArrivals(stop.id!));
//               },
//               child: const Text('View Arrivals'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
