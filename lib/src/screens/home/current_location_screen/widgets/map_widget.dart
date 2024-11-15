import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapWidget extends StatelessWidget {
  final Completer<GoogleMapController> mapController;
  final LatLng location;

  const MapWidget({
    required this.mapController,
    required this.location,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      onMapCreated: (controller) => mapController.complete(controller),
      initialCameraPosition: CameraPosition(
        target: location,
        zoom: 14,
      ),
      markers: {
        Marker(
          markerId: const MarkerId('currentLocation'),
          position: location,
        ),
      },
    );
  }
}
