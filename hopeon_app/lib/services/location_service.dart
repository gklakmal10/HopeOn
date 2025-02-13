import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:location/location.dart';

class LocationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Timer? _locationTimer;
  final String userId;
  final String baseUrl = "http://13.61.16.165:8080/api/v1/vehicle";

  Location location = new Location();
  bool _serviceEnabled = false;
  PermissionStatus? _permissionStatus;

  LocationService({required this.userId});

  Future<Map<String, dynamic>?> getByDriver(String id) async {
    final url = Uri.parse("$baseUrl/getByDriver?driverId=$id");
    try {
      final response = await http.get(
          url,
          headers: {"Content-Type": "application/json"}
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data["status"] == 200 && data["object"] != null) {
          return data["object"];
        }
      }
      return null;
    } catch (e) {
      print("Login error: $e");
      return null;
    }
  }

  Future<void> startLocationTracking() async {

    _serviceEnabled= await location.serviceEnabled();

    if(!_serviceEnabled){
      _serviceEnabled = await location.requestService();
      if(!_serviceEnabled){
        return;
      }
    }

    _permissionStatus = await location.hasPermission();
    if(_permissionStatus == PermissionStatus.denied){
      _permissionStatus = await location.requestPermission();
      if(_permissionStatus != PermissionStatus.granted){
        return;
      }
    }

    // Start periodic location updates
    _locationTimer = Timer.periodic(const Duration(seconds: 5), (timer) async {
      try {
        // Save to Firebase
        await _saveLocationToFirebase(await location.getLocation());
      } catch (e) {
        print('Error getting location: $e');
      }
    });
  }

  Future<void> _saveLocationToFirebase(LocationData position) async {
    try {
      await _firestore
          .collection('locations')
          .doc(userId)
          .set({
        'latitude': position.latitude,
        'longitude': position.longitude,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error saving location to Firebase: $e');
    }
  }

  Stream<DocumentSnapshot> getLocationUpdates(String targetUserId) {
    return _firestore
        .collection('locations')
        .doc(targetUserId)
        .snapshots();
  }

  void stopLocationTracking() {
    _locationTimer?.cancel();
  }

  // Example of how to handle location updates in your app
  void listenToLocationUpdates(String targetUserId) {
    getLocationUpdates(targetUserId).listen((DocumentSnapshot snapshot) {
      if (snapshot.exists) {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        double latitude = data['latitude'];
        double longitude = data['longitude'];
        // Handle the location update
        print('Location updated - Lat: $latitude, Long: $longitude');
      }
    });
  }
}