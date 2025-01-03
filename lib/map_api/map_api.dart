import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class map_api extends StatefulWidget {
  const map_api({super.key});

  @override
  State<map_api> createState() => _map_apiState();
}

class _map_apiState extends State<map_api> {
  static const LatLng _pGooglePlex = LatLng(37.4223, -122.0048);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
      initialCameraPosition: CameraPosition(target: _pGooglePlex, zoom: 13),
      ),
    );
  }
}
