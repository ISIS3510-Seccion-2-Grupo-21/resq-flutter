import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class MapView extends StatefulWidget {
  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  late GoogleMapController mapController;
  Set<Marker> markers = {};

  @override
  void initState() {
    super.initState();
    _checkLocationPermission();
  }

  Future<void> _checkLocationPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        return;
      }
    }

    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    _updateMarkers(position.latitude, position.longitude);
  }

  void _updateMarkers(double latitude, double longitude) {
    setState(() {
      markers = {
        Marker(
          markerId: MarkerId('1'),
          position: LatLng(latitude, longitude),
          infoWindow: InfoWindow(title: 'Your Location'),
        ),
        Marker(
          markerId: MarkerId('2'),
          position: LatLng(4.6018, -74.0661),
          infoWindow: InfoWindow(title: 'ML'),
        ),
        Marker(
          markerId: MarkerId('3'),
          position: LatLng(4.604400872503055, -74.0659650900807),
          infoWindow: InfoWindow(title: 'SD'),
        ),
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Map View'),
      ),
      body: GoogleMap(
        onMapCreated: (controller) {
          mapController = controller;
        },
        initialCameraPosition: CameraPosition(
          target: LatLng(4.6018, -74.0661),
          zoom: 15.0,
        ),
        markers: markers,
        myLocationEnabled: true,
      ),
    );
  }
}
