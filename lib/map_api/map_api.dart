import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class map_api extends StatefulWidget {
  const map_api({super.key});

  @override
  State<map_api> createState() => _MapApiState();
}

class _MapApiState extends State<map_api> {
  late GoogleMapController _mapController;
  LatLng _currentPosition = const LatLng(37.4223, -122.0048);
  Marker? _userMarker;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  // Fetch current location
  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    // Request location permission
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // Get the current position
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    setState(() {
      _currentPosition = LatLng(position.latitude, position.longitude);
      _userMarker = Marker(
        markerId: const MarkerId("currentLocation"),
        position: _currentPosition,
        infoWindow: const InfoWindow(title: "You are here"),
      );
    });

    // Move camera to current position
    _mapController.animateCamera(
      CameraUpdate.newLatLng(_currentPosition),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Map with GPS Tracking')),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(target: _currentPosition, zoom: 13),
        markers: _userMarker != null ? {_userMarker!} : {},
        onMapCreated: (GoogleMapController controller) {
          _mapController = controller;
        },
        myLocationEnabled: true, // Enable blue dot for user's location
        myLocationButtonEnabled: true, // Enable button to center on user's location
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.location_searching),
        onPressed: _getCurrentLocation,
      ),
    );
  }
}
