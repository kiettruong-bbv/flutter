import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapView extends StatefulWidget {
  const GoogleMapView({Key? key}) : super(key: key);

  @override
  State<GoogleMapView> createState() => _GoogleMapViewState();
}

class _GoogleMapViewState extends State<GoogleMapView> {
  late GoogleMapController mapController;
  late StreamSubscription<Position> positionStream;

  bool _isTracking = false;
  late Position _previousPosition;

  final Set<Marker> _markers = {};
  final List<LatLng> _listPoint = [];
  final Map<PolylineId, Polyline> _polylines = {};

  final CameraPosition _initialLocation = const CameraPosition(
    target: LatLng(0.0, 0.0),
    zoom: 18,
  );

  final LocationSettings _locationSettings = const LocationSettings(
    accuracy: LocationAccuracy.high,
    distanceFilter: 30,
  );

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 6,
            child: _buildMap(),
          ),
          Expanded(
            flex: 1,
            child: _buildBottomView(),
          ),
        ],
      ),
    );
  }

  Widget _buildMap() {
    return GoogleMap(
      initialCameraPosition: _initialLocation,
      polylines: Set<Polyline>.of(_polylines.values),
      markers: Set<Marker>.from(_markers),
      myLocationEnabled: true,
      myLocationButtonEnabled: true,
      mapType: MapType.normal,
      zoomGesturesEnabled: true,
      zoomControlsEnabled: false,
      onMapCreated: (GoogleMapController controller) async {
        mapController = controller;

        final position = await _getCurrentLocation();
        _previousPosition = position;
        _moveToLocation(position);
      },
    );
  }

  Widget _buildBottomView() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        const Text('LEFT'),
        _buildCenterButton(),
        const Text('RIGHT'),
      ],
    );
  }

  Widget _buildCenterButton() {
    return ElevatedButton(
      onPressed: () {
        _isTracking ? _stopTracking() : _startTracking();
      },
      style: ElevatedButton.styleFrom(
        shape: const CircleBorder(),
        padding: const EdgeInsets.all(20),
        primary: Colors.blue, // <-- Button color
        onPrimary: Colors.red, // <-- Splash color
      ),
      child: Icon(
        _isTracking ? Icons.stop : Icons.play_arrow,
        color: Colors.white,
      ),
    );
  }

  void _startTracking() {
    setState(() {
      _isTracking = true;
    });

    positionStream =
        Geolocator.getPositionStream(locationSettings: _locationSettings)
            .listen((Position? position) async {
      if (position != null) {
        await _moveToLocation(position);
        await _drawPath(_previousPosition, position);
        _placeMarker(position);
        _previousPosition = position;
      }
    });
  }

  void _stopTracking() {
    setState(() {
      _isTracking = false;
    });

    positionStream.cancel();
  }

  Future _drawPath(
    Position start,
    Position end,
  ) async {
    final PolylineId polylineId =
        PolylineId('${start.latitude}-${end.latitude}');

    final Polyline polyline = Polyline(
      polylineId: polylineId,
      consumeTapEvents: true,
      color: Colors.red,
      width: 5,
      points: _listPoint,
    );

    _listPoint.add(LatLng(end.latitude, end.longitude));

    setState(() {
      _polylines[polylineId] = polyline;
    });
  }

  void _placeMarker(Position position) {
    String startCoordinatesString =
        '(${position.latitude}, ${position.longitude})';

    Marker marker = Marker(
      markerId: MarkerId(startCoordinatesString),
      position: LatLng(position.latitude, position.longitude),
      infoWindow: InfoWindow(
        title: 'Start ${position.latitude}',
      ),
      icon: BitmapDescriptor.defaultMarker,
    );

    _markers.add(marker);
  }

  Future _moveToLocation(Position position) async {
    await mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(
            position.latitude,
            position.longitude,
          ),
          zoom: 18.0,
        ),
      ),
    );
  }

  Future<Position> _getCurrentLocation() async {
    return Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }
}
