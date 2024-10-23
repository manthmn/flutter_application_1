import 'package:flutter/material.dart';
import 'package:stop_finder/constants/app_constants.dart';

class MainMarker extends StatefulWidget {
  const MainMarker({super.key});

  @override
  State<MainMarker> createState() => _MainMarkerState();
}

class _MainMarkerState extends State<MainMarker> with SingleTickerProviderStateMixin {
  late AnimationController _controller; // Controller for managing the animation
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    // Initialize the animation controller
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
      upperBound: 1.0,
    )..repeat(reverse: true); // Repeat the animation in reverse

    _animation = Tween<double>(begin: 0.7, end: 1.0).animate(_controller);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            // Animating circle
            Container(
              width: 60 * _animation.value,
              height: 60 * _animation.value,
              decoration: BoxDecoration(
                color: AppConstants.mainMarkerColor.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
            ),
            // Static location icon
            Icon(
              Icons.location_on,
              color: AppConstants.mainMarkerColor,
              size: 40,
            ),
          ],
        );
      },
    );
  }
}
