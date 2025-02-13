import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hopeon_app/screens/driver_screens/DriverBottomNavBar.dart';
import 'package:hopeon_app/screens/parent_screens/ParentBottomNavBar.dart';
import 'package:hopeon_app/services/location_service.dart';
import 'package:hopeon_app/constants.dart';

class ParentTrackMyBusScreen extends StatefulWidget {
  final String driverId;
  final String type;
  const ParentTrackMyBusScreen({super.key, required this.driverId, required this.type});

  @override
  State<ParentTrackMyBusScreen> createState() => _ParentTrackMyBusScreenState();
}

class _ParentTrackMyBusScreenState extends State<ParentTrackMyBusScreen> {
  late LatLng startLocation ;
  late LatLng endLocation;

  late final LocationService _locationService;
  LatLng? currentPosition;
  Map<PolylineId, Polyline> polylines = {};
  StreamSubscription<DocumentSnapshot>? _locationSubscription;
  BitmapDescriptor? busIcon;


  bool _isLocations = false;

  void loadStartEndPoints()async{
    _locationService = LocationService(userId: widget.driverId);
    listenToDriverLocation();
    Map<String, dynamic>? res = await _locationService.getByDriver(widget.driverId);

    if(res != null){
      if(res["startLat"]!=null && res["startLong"]!=null && res["endLat"]!=null && res["endLong"]!=null){
        setState(() {
          _isLocations = true;
          startLocation = LatLng(double.parse(res["startLat"]), double.parse(res["startLong"]));
          endLocation = LatLng(double.parse(res["endLat"]), double.parse(res["endLong"]));
        });
        WidgetsBinding.instance
            .addPostFrameCallback((_) async => await initializeMap());
        loadCustomMarker();

      }
    }

  }
  
  @override
  void initState() {
    loadStartEndPoints();
    super.initState();

  }


  /// Load custom marker icon
  Future<void> loadCustomMarker() async {
    final BitmapDescriptor icon = await BitmapDescriptor.asset(
      const ImageConfiguration(size: Size(48, 48)), // Adjust size if needed
      'assets/images/bus.png', // Ensure this file is in assets/
    );
    setState(() {
      busIcon = icon;
    });
  }

  Future<void> initializeMap() async {
    final coordinates = await fetchPolylinePoints();
    generatePolyLineFromPoints(coordinates);
  }

  void listenToDriverLocation() {
    _locationSubscription = _locationService
        .getLocationUpdates(widget.driverId)
        .listen((DocumentSnapshot snapshot) {
      if (snapshot.exists) {
        final data = snapshot.data() as Map<String, dynamic>;
        print(data);
        final double latitude = data['latitude'];
        final double longitude = data['longitude'];

        if (mounted) {
          setState(() {
            currentPosition = LatLng(latitude, longitude);
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _locationSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text(
        "Track Vehicle Location",
        style: TextStyle(
            fontWeight: FontWeight.bold, fontSize: 25, color: Colors.white),
      ),
      backgroundColor: const Color.fromRGBO(37, 100, 255, 1.0),
      automaticallyImplyLeading: false,
      toolbarHeight: 100.0,

    ),
    body:  _isLocations ? currentPosition == null || busIcon == null
        ? const Center(child: CircularProgressIndicator())
        : GoogleMap(
      initialCameraPosition: CameraPosition(
        target: currentPosition!,
        zoom: 13,
      ),
      markers: {
        Marker(
          markerId: const MarkerId('currentLocation'),
          icon: busIcon!, // Use custom bus icon
          position: currentPosition!,
        ),
        Marker(
          markerId: const MarkerId('sourceLocation'),
          icon: BitmapDescriptor.defaultMarker,
          position: startLocation,
        ),
        Marker(
          markerId: const MarkerId('destinationLocation'),
          icon: BitmapDescriptor.defaultMarker,
          position: endLocation,
        )
      },
      polylines: Set<Polyline>.of(polylines.values),
    ): const Center(child: Text("No Start and End Locations set"),),
    bottomNavigationBar: widget.type == "DRIVER" ? DriverBottomNavBar(selectedScreen: 1): ParentBottomNavBar(selectedScreen: 1),
  );

  Future<List<LatLng>> fetchPolylinePoints() async {
    final polylinePoints = PolylinePoints();

    final result = await polylinePoints.getRouteBetweenCoordinates(
        request: PolylineRequest(
          origin: PointLatLng(startLocation.latitude, startLocation.longitude),
          destination:
          PointLatLng(endLocation.latitude, endLocation.longitude),
          mode: TravelMode.driving,
        ),
        googleApiKey: googleMapsApiKey);

    debugPrint("Polyline Status: ${result.status}");
    debugPrint("Error Message: ${result.errorMessage}");
    debugPrint("Points Count: ${result.points.length}");

    if (result.points.isNotEmpty) {
      return result.points
          .map((point) => LatLng(point.latitude, point.longitude))
          .toList();
    } else {
      return [];
    }
  }

  Future<void> generatePolyLineFromPoints(
      List<LatLng> polylineCoordinates) async {
    const id = PolylineId('polyline');

    final polyline = Polyline(
      polylineId: id,
      color: Colors.blueAccent,
      points: polylineCoordinates,
      width: 5,
    );

    setState(() => polylines[id] = polyline);
  }
}
