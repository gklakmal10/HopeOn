import 'package:flutter/material.dart';
import 'package:hopeon_app/screens/driver_screens/DriverTripTrackingScreen.dart';
import 'package:hopeon_app/services/trip_service.dart';

import '../../services/location_service.dart';

class DriverTripProgressScreen extends StatefulWidget {
  final Map<String, dynamic> trip;

  const DriverTripProgressScreen({super.key, required this.trip});

  @override
  State<DriverTripProgressScreen> createState() =>
      _DriverTripProgressScreenState();
}

class _DriverTripProgressScreenState extends State<DriverTripProgressScreen> {
  late bool isStart;
  final TripService _tripService = TripService();
  late final LocationService _locationService;
  late Map<String, dynamic> tripData;
  bool _isLoading = false;

  void _handleStartTrip() async {
    setState(() {
      _isLoading = true;
    });

    Map<String, dynamic> res = await _tripService.saveTrip({
      "tripDate": DateTime.now().toIso8601String().split("T")[0],
      "type": tripData['type'],
      "driverId": tripData["driverId"]
    });
    if (res['success']) {
      _locationService.startLocationTracking();
      setState(() {
        tripData = res['body'];
        _isLoading = false;
        isStart = true;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _handleMarkPicked(String attendance) async {
    setState(() {
      _isLoading = true;
    });

    Map<String, dynamic> res = await _tripService.markPickUp(attendance);
    if (res['success']) {
      setState(() {
        tripData = res['body'];
        _isLoading = false;
        isStart = true;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _handleEndTrip(String id) async {
    setState(() {
      _isLoading = true;
    });

    Map<String, dynamic> res = await _tripService.endTrip(id);
    if (res['success']) {
      _locationService.stopLocationTracking();
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  DriverTripTrackingScreen(id: widget.trip["driverId"].toString())
          ));
      setState(() {
        _isLoading = false;
      });

    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    _locationService = LocationService(userId: widget.trip["driverId"].toString());
    setState(() {
      tripData = widget.trip;
      isStart = widget.trip["status"] == "PENDING" ? false : true;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      DriverTripTrackingScreen(id: widget.trip["driverId"].toString())
            ));
          },
        ),
        toolbarHeight: 100.0,
        title: Padding(
          padding: const EdgeInsets.only(top: 15),
          child: Text("${tripData['type'] == "TO_SCHOOL"? "To School":"To Home"} - ${DateTime.now().toIso8601String().split("T")[0]}",
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
      body: isStart
          ? ((tripData["attendanceList"]
          .where((att) => att["picked"] == true)
          .length) == tripData["pickedCount"] && tripData["pickedCount"] != 0) ? Center(child: MaterialButton(
        padding: const EdgeInsets.all(10),
        color: const Color.fromRGBO(37, 100, 255, 1.0),
        onPressed: ()=>{
          _handleEndTrip(tripData["id"].toString())
        },
        minWidth: 300,
        child: _isLoading
            ? const CircularProgressIndicator(color: Colors.white)
            : const Text("End Trip",
            style: TextStyle(fontSize: 16, color: Colors.white)),
      ),): Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(10),
            child: Text(
              "Pick All students to complete",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
            ),
          ),
          Expanded(
            // Add this to constrain ListView's height
            child: ListView.builder(
              itemCount: tripData["attendanceList"].length,
              itemBuilder: (context, index) {
                final std = tripData["attendanceList"][index];
                return ListTile(
                  leading: const CircleAvatar(
                    backgroundImage:
                    NetworkImage("https://i.pravatar.cc/150?img=4"),
                    radius: 28,
                  ),
                  title: Text(
                    std['fullName'],
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  // subtitle: Text(
                  //   std['contactNo'],
                  //   maxLines: 1,
                  //   overflow: TextOverflow.ellipsis,
                  //   style: TextStyle(color: Colors.grey[600]),
                  // ),
                  trailing: SizedBox(
                      child: Checkbox(
                        value: std['picked'],
                        onChanged: (value) {
                          _handleMarkPicked(std['id'].toString());
                        },
                      )),
                );
              },
            ),
          ),
        ],
      )
          : Center(
        child: MaterialButton(
          padding: const EdgeInsets.all(10),
          color: const Color.fromRGBO(37, 100, 255, 1.0),
          onPressed: _handleStartTrip,
          minWidth: 300,
          child: _isLoading
              ? const CircularProgressIndicator(color: Colors.white)
              : const Text("Start Trip",
              style: TextStyle(fontSize: 16, color: Colors.white)),
        ),
      ),
    );
  }
}
