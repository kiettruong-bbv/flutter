import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:geolocator/geolocator.dart';

class OpenStreetMapView extends StatefulWidget {
  const OpenStreetMapView({Key? key}) : super(key: key);

  @override
  State<OpenStreetMapView> createState() => _OpenStreetMapViewState();
}

class _OpenStreetMapViewState extends State<OpenStreetMapView> {
  late final Future? _initFuture;

  late MapController _mapController;
  late StreamSubscription<Position> positionStream;

  bool _isTracking = false;
  GeoPoint? _previousLocation;
  late GeoPoint _initLocation;

  final List<GeoPoint> _listPoint = [];

  final LocationSettings _locationSettings = const LocationSettings(
    accuracy: LocationAccuracy.high,
    distanceFilter: 30,
  );

  @override
  void initState() {
    super.initState();
    _initFuture = _initMap();
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
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
    return FutureBuilder(
      future: _initFuture,
      builder: (context, snapshot) {
        return OSMFlutter(
          controller: _mapController,
          trackMyPosition: _isTracking,
          initZoom: 18,
          minZoomLevel: 2,
          maxZoomLevel: 18,
          stepZoom: 1.0,
          userLocationMarker: UserLocationMaker(
            personMarker: const MarkerIcon(
              icon: Icon(
                Icons.location_history_rounded,
                color: Colors.red,
                size: 48,
              ),
            ),
            directionArrowMarker: const MarkerIcon(
              icon: Icon(
                Icons.double_arrow,
                size: 48,
              ),
            ),
          ),
          // roadConfiguration: RoadConfiguration(
          //   startIcon: const MarkerIcon(
          //     icon: Icon(
          //       Icons.person,
          //       size: 64,
          //       color: Colors.brown,
          //     ),
          //   ),
          //   roadColor: Colors.yellowAccent,
          // ),
          // markerOption: MarkerOption(
          //   defaultMarker: const MarkerIcon(
          //     icon: Icon(
          //       Icons.person_pin_circle,
          //       color: Colors.blue,
          //       size: 56,
          //     ),
          //   ),
          // ),
        );
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

  Future _initMap() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    GeoPoint geoPositioon = GeoPoint(
      latitude: position.latitude,
      longitude: position.longitude,
    );

    _mapController = MapController(
      initMapWithUserPosition: true,
      initPosition: geoPositioon,
    );

    _initLocation = geoPositioon;
    _previousLocation = geoPositioon;
  }

  Future _startTracking() async {
    setState(() {
      _isTracking = true;
    });

    await _mapController.enableTracking();

    positionStream =
        Geolocator.getPositionStream(locationSettings: _locationSettings)
            .listen((Position? position) async {
      if (position != null && _previousLocation != null) {
        await _drawPath(
          _initLocation,
          GeoPoint(latitude: position.latitude, longitude: position.longitude),
        );
        _previousLocation = GeoPoint(
          latitude: position.latitude,
          longitude: position.longitude,
        );
      }
    });
  }

  Future _stopTracking() async {
    setState(() {
      _isTracking = false;
    });

    await _mapController.disabledTracking();

    positionStream.cancel();
  }

  Future _drawPath(
    GeoPoint start,
    GeoPoint end,
  ) async {
    RoadInfo roadInfo = await _mapController.drawRoad(
      start,
      end,
      roadType: RoadType.bike,
      intersectPoint: _listPoint,
      roadOption: const RoadOption(
        roadWidth: 5,
        roadColor: Colors.red,
        showMarkerOfPOI: true,
        zoomInto: false,
      ),
    );
    _listPoint.add(GeoPoint(
      latitude: end.latitude,
      longitude: end.longitude,
    ));
    print("${roadInfo.distance}km");
    print("${roadInfo.duration}sec");
  }
}
