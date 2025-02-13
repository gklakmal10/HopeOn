import 'package:flutter/material.dart';
import 'package:hopeon_app/screens/common_screens/NeedHelpScreen.dart';
import 'package:hopeon_app/screens/parent_screens/AttendanceMarkScreen.dart';
import 'package:hopeon_app/screens/common_screens/DriverInfoScreen.dart';
import 'package:hopeon_app/screens/parent_screens/ParentAlertScreen.dart';
import 'package:hopeon_app/screens/parent_screens/ParentBottomNavBar.dart';
import 'package:hopeon_app/screens/parent_screens/ParentTrackMyBusScreen.dart';
import 'package:hopeon_app/screens/common_screens/StudentInfoScreen.dart';
import 'package:hopeon_app/services/parent_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ParentDashboardScreen extends StatefulWidget {
  const ParentDashboardScreen({Key? key}) : super(key: key);

  @override
  _ParentDashboardScreenState createState() => _ParentDashboardScreenState();
}

class _ParentDashboardScreenState extends State<ParentDashboardScreen> {
  late Map<String, String?> user;
  final ParentService _parentService = ParentService();
  late Map<String, dynamic>? student;
  bool _isLoading = false;

  Future<void> getUser() async {
    setState(() {
      _isLoading = true;
    });
    final prefs = await SharedPreferences.getInstance();
    Map<String, dynamic>? fetchUser =
    await _parentService.getStudent(prefs.getString("user_id")!);
    if (fetchUser != null) {
      setState(() {
        student = fetchUser;
        user={
          "id": prefs.getString("user_id"),
          "email": fetchUser["email"],
          "type": fetchUser["type"],
          "fullName": fetchUser["fullName"],
          "imageUrl": fetchUser["imageUrl"]
        };
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    getUser();
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading ? const Center(
        child: CircularProgressIndicator(color: Colors.blue),
      ):Column(
        children: [
          // Top Section with Gradient Background
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(30, 60, 10, 20),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF3F51B5), Color(0xFF64B5F6)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: user["imageUrl"] != null
                      ? NetworkImage(user["imageUrl"]!)
                      : AssetImage("assets/images/profile-parent.png",),),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Welcome",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    Text(
                      user['fullName']!,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Grid Layout for Features
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              crossAxisSpacing: 10,
              mainAxisSpacing: 0,
              children: [
                _buildFeatureIcon(Icons.assignment, "Attendance", onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AttendanceMarkScreen(id: user['id']!,)),
                  );
                }),
                _buildFeatureIcon(Icons.directions_bus, "Track My Bus", onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ParentTrackMyBusScreen(driverId: student!['driverId'].toString(),type: "STUDENT",)),
                  );
                }),
                _buildFeatureIcon(Icons.notifications, "Alert",  onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ParentAlertScreen(driverId: student!["driverId"].toString(),)),
                  );
                }),
                _buildFeatureIcon(Icons.perm_identity, "Driver Info", onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DriverInfoScreen(id: student!["driverId"].toString(),)),
                  );
                }),
                _buildFeatureIcon(Icons.person, "Student Info", onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => StudentInfoScreen(id: user['id']!,)),
                  );
                }),
                _buildFeatureIcon(Icons.headset_mic, "Need Help", onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => NeedHelpScreen()),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: const ParentBottomNavBar(selectedScreen: 0),
    );
  }

  // Function to Create Feature Icon with Adjustable Size
  Widget _buildFeatureIcon(IconData icon, String title,
      {int badgeCount = 0, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 100,
        height: 100,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Column(children: [
              Container(
                width: 120,
                height: 120,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [Color(0xFF3F51B5), Color(0xFF64B5F6)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(icon, size: 70, color: Colors.white),
                    const SizedBox(height: 5),
                  ],
                ),
              ),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ]),
            if (badgeCount > 0)
              Positioned(
                right: 35,
                top: 10,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    badgeCount.toString(),
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}