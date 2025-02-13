import 'package:flutter/material.dart';
import 'package:hopeon_app/services/driver_service.dart';

class DriverInfoScreen extends StatefulWidget {
  final String? id;

  const DriverInfoScreen({super.key, required this.id});

  @override
  State<DriverInfoScreen> createState() => _DriverInfoScreenState();
}

class _DriverInfoScreenState extends State<DriverInfoScreen> {
  final DriverService _driverService = DriverService();
  late Map<String, dynamic>? driver;
  bool _isLoading = false;

  void _loadDriverData() async {
    if (widget.id != null) {
      setState(() {
        _isLoading = true;
      });
      Map<String, dynamic>? fetchUser =
          await _driverService.getDriver(widget.id!);

      if (fetchUser != null) {
        setState(() {
          driver = fetchUser;
          _isLoading = false;
        });
      } else {
        driver = null;
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      driver = null;
    }
  }

  @override
  void initState() {
    _loadDriverData();
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
              Navigator.pop(context);
            },
          ),
          title: const Text(
            "Driver Info",
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: _isLoading
            ? const Center(
                child: CircularProgressIndicator(color: Colors.blue),
              )
            : driver == null
                ? const Center(child: Text("Driver details not available", style: TextStyle(fontSize: 18,)))
                : SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          // Profile Image
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                radius: 50,
                                backgroundImage: driver?["imageUrl"] != null
                                    ? NetworkImage(driver?["imageUrl"]!)
                                    : AssetImage("assets/images/profile-driver.png",) // Replace with actual image URL
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // Student Information
                          SizedBox(
                            width: double.infinity,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                infoText("Driver Name", driver?['fullName']),
                                infoText(
                                    "Contact Number", driver?['contactNo']),
                                infoText("Experience",
                                    driver?['experience'] + " Years"),
                                infoText("NIC Number", driver?['nicNo']),
                                infoText("Age", driver?['age'] + " Years"),
                                infoText(
                                    "Vehicle Number", driver?['vehicleNo']),
                                infoText(
                                    "Vehicle Type", driver?['vehicleDetails']),
                                infoText(
                                    "Route Details", driver?['vehicleRoute']),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ));
  }

  // Widget for each info row
  Widget infoText(String title, String value) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 30, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }
}
