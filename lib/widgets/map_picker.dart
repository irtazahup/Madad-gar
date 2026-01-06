import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapPickerScreen extends StatefulWidget {
  final LatLng initialPosition;
  const MapPickerScreen({super.key, required this.initialPosition});

  @override
  State<MapPickerScreen> createState() => _MapPickerScreenState();
}

class _MapPickerScreenState extends State<MapPickerScreen> {
  late LatLng _pickedLocation;

  @override
  void initState() {
    super.initState();
    _pickedLocation = widget.initialPosition;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Drag to Pick Location")),
      body: Stack(
        children: [
          FlutterMap(
            options: MapOptions(
              initialCenter: widget.initialPosition,
              initialZoom: 15,
              onPositionChanged: (position, hasGesture) {
                // Update the coordinates as the user moves the map
                if (hasGesture) {
                  setState(() {
                    _pickedLocation = position.center;
                  });
                }
              },
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.your.app', // Identify your app
              ),
            ],
          ),
          // A fixed marker in the center of the screen
          const Center(
            child: Icon(Icons.location_on, size: 40, color: Colors.red),
          ),
          // Confirm Button
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context, _pickedLocation),
              child: const Text("Confirm This Location"),
            ),
          ),
        ],
      ),
    );
  }
}
