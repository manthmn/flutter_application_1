import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:stop_finder/constants/app_constants.dart';
import 'package:stop_finder/constants/user_data.dart';
import 'package:stop_finder/models/line_vehicle_status.dart';
import 'package:stop_finder/models/nearby_stops.dart';
import 'package:stop_finder/models/vehicle_details.dart';
import 'package:stop_finder/place_bloc/place_bloc.dart';

class StopBottomSheet extends StatefulWidget {
  final dynamic state;
  final PlaceBloc placeBloc;
  final int? scrollToIndex;

  const StopBottomSheet({Key? key, required this.state, required this.placeBloc, this.scrollToIndex}) : super(key: key);

  @override
  State<StopBottomSheet> createState() => _StopBottomSheetState();
}

class _StopBottomSheetState extends State<StopBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.4,
      minChildSize: 0.4,
      maxChildSize: 0.95,
      snap: true,
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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Nearby Stops',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            UserData.placemarks?[0].subAdministrativeArea ?? '',
                            style: TextStyle(
                              color: AppConstants.locationTextColor,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.my_location, size: 28, color: AppConstants.locationTextColor),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Builder(
                    builder: (context) {
                      if (widget.state is PlaceLoading) {
                        return buildShimmer(); // Show loading shimmer
                      } else if (widget.state is StopsLoaded || widget.state is StopsVehicleLoaded) {
                        return _buildStopListView(scrollController, widget.state);
                      } else if (widget.state is SelectedStopLoaded) {
                        return _buildStopDetailView(
                          scrollController,
                          widget.state.stops[widget.state.selectedStopIndex],
                          widget.state.stopVehicleMap,
                        );
                      } else if (widget.state is PlaceError) {
                        return _buildStopErrorView(widget.state);
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

  /// Builds a shimmer effect for loading stops.
  Widget buildShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView.builder(
        itemCount: 6, // Number of shimmer items
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
                      const SizedBox(width: 8),
                      Container(width: 50, height: 20, color: Colors.white),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Container(width: double.infinity, height: 20, color: Colors.white),
                  const SizedBox(height: 5),
                  Container(width: 100, height: 20, color: Colors.white),
                  const SizedBox(height: 5),
                  Container(width: 150, height: 20, color: Colors.white),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Container(width: 30, height: 20, color: Colors.white),
                      const SizedBox(width: 5),
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

  /// Displays an error message with a retry button.
  Center _buildStopErrorView(PlaceError state) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              state.message,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => widget.placeBloc.add(FetchNearbyStops(
                UserData.currentPosition!.latitude,
                UserData.currentPosition!.longitude,
              )),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds a list view of nearby stops.
  Widget _buildStopListView(ScrollController scrollController, dynamic state) {
    return ListView.builder(
      controller: scrollController,
      itemCount: state.stops.length,
      itemBuilder: (context, index) {
        StopPoint stop = state.stops[index];
        String walkingDistance = "${stop.distance!.toStringAsFixed(0)}m";
        Map<String, LineVehicleStatus> lineVehicleStatus = {};

        // Map vehicle statuses to lines
        state.stopVehicleMap[stop.id]?.forEach((vehicle) {
          if (lineVehicleStatus[vehicle.lineName!] == null) {
            lineVehicleStatus[vehicle.lineName!] = LineVehicleStatus(
              lineId: vehicle.lineId,
              lineName: vehicle.lineName,
              destinationName: vehicle.destinationName,
              timeToStationString: '',
              timeToStationList: [],
            );
          }
          lineVehicleStatus[vehicle.lineName!]?.timeToStationList.add(vehicle.timeToStation!);
        });

        // Process time to station
        lineVehicleStatus.forEach((lineId, vehicleStatus) {
          vehicleStatus.timeToStationList.sort();
          if (vehicleStatus.timeToStationList.length > 3) {
            vehicleStatus.timeToStationList = vehicleStatus.timeToStationList.sublist(0, 3);
          }
          vehicleStatus.timeToStationString = vehicleStatus.timeToStationList.map((time) {
            int minutes = (time / 60).floor();
            return '${minutes == 0 ? 'Due' : minutes}';
          }).join(', ');
        });

        return _buildStopCard(index, stop, walkingDistance, lineVehicleStatus);
      },
    );
  }

  /// Builds a card for each stop, displaying its details.
  Widget _buildStopCard(
      int index, StopPoint stop, String walkingDistance, Map<String, LineVehicleStatus> lineVehicleStatus) {
    return GestureDetector(
      onTap: () {
        widget.placeBloc.add(StopContinuousUpdates());
        widget.placeBloc.add(FetchSelectedStopDetails(index));
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.directions_bus, color: AppConstants.stopColor, size: 26),
                      const SizedBox(width: 6),
                      Text(
                        stop.stopLetter ?? '',
                        style: TextStyle(color: AppConstants.stopColor, fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        walkingDistance,
                        style: TextStyle(color: Colors.grey[600], fontSize: 14),
                      ),
                      const SizedBox(width: 6),
                      const Icon(Icons.directions_walk, size: 20),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                stop.commonName!,
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
              ),
              const SizedBox(height: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: lineVehicleStatus.entries.map((entry) {
                  return _buildLineCard(entry);
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds a card for each bus line associated with a stop.
  Widget _buildLineCard(MapEntry<String, LineVehicleStatus> entry) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 32,
            width: 60,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppConstants.lineNameColor,
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: Text(
              entry.value.lineName ?? '',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                entry.value.destinationName ?? '',
                style: const TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.w300),
              ),
              Text(
                '${entry.value.timeToStationString} min',
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Builds the detail view for a selected stop.
  Widget _buildStopDetailView(
    ScrollController scrollController,
    StopPoint stop,
    Map<String, List<VehicleDetails>> stopVehicleMap,
  ) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: SingleChildScrollView(
        controller: scrollController,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 50,
                  width: 50,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 243, 241, 241),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black, size: 20, weight: 10),
                    onPressed: () {
                      widget.placeBloc.add(BackToNearbyStops());
                    },
                  ),
                ),
                Container(
                  height: 50,
                  width: 50,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppConstants.stopColor,
                    shape: BoxShape.circle,
                  ),
                  child: stop.stopLetter != null
                      ? Text(
                          stop.stopLetter!,
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 20),
                        )
                      : const Icon(Icons.directions_bus, color: Colors.white, size: 20),
                ),
                SizedBox(
                  height: 56,
                  width: 56,
                  child: Row(
                    children: [
                      Text(
                        "${stop.distance!.toStringAsFixed(0)}m",
                        style: TextStyle(color: Colors.grey[600], fontSize: 14),
                      ),
                      const SizedBox(width: 6),
                      const Icon(Icons.directions_walk, size: 20),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            Text(
              stop.commonName!,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 20),
            Column(
              children: stopVehicleMap[stop.id!]!.map((vehicle) {
                int minutes = ((vehicle.timeToStation ?? 0) / 60).floor();
                return Container(
                  height: 72,
                  padding: const EdgeInsets.all(12),
                  decoration: const BoxDecoration(border: Border(bottom: BorderSide(width: 0.5, color: Colors.grey))),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(
                                vehicle.lineName ?? '',
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(width: 8),
                              Text(vehicle.direction ?? ''),
                            ],
                          ),
                          Text('${minutes == 0 ? 'Due' : minutes} min'),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(vehicle.destinationName ?? ''),
                          Text(
                            vehicle.vehicleId ?? '',
                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
