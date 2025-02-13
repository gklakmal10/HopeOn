import 'package:flutter/material.dart';
import 'package:hopeon_app/screens/driver_screens/DriverChatScreen.dart';
import 'package:hopeon_app/screens/driver_screens/DriverDashboardScreen.dart';
import 'package:hopeon_app/screens/driver_screens/DriverProfileScreen.dart';
import 'package:hopeon_app/screens/parent_screens/ParentChatScreen.dart';
import 'package:hopeon_app/screens/parent_screens/ParentDashboardScreen.dart';
import 'package:hopeon_app/screens/parent_screens/ParentProfileScreen.dart';
import 'package:hopeon_app/screens/parent_screens/ParentTrackMyBusScreen.dart';
import 'package:hopeon_app/services/driver_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DriverBottomNavBar extends StatefulWidget {
  final int selectedScreen;
  const DriverBottomNavBar({super.key, required this.selectedScreen});
  @override
  _DriverBottomNavBarState createState() => _DriverBottomNavBarState();
}

class _DriverBottomNavBarState extends State<DriverBottomNavBar> {
  late int _selectedIndex;
  late Map<String, String?> user;
  final DriverService _driverService = DriverService();
  late Map<String, dynamic>? driver;
  bool _isLoading = false;

  Future<void> getUser() async {
    setState(() {
      _isLoading = true;
    });
    final prefs = await SharedPreferences.getInstance();
    Map<String, dynamic>? fetchUser =
    await _driverService.getDriver(prefs.getString("user_id")!);
    if (fetchUser != null) {
      setState(() {
        driver = fetchUser;
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
  void _onItemTapped(int index) {
    if (driver == null) {
      // Handle the case when the driver data is not loaded yet
      // For example, show a loading indicator or a message to the user.
      return;
    }

    if (index == 0 && _selectedIndex != 0) {
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => DriverDashboardScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            var fadeAnimation = Tween(begin: 1.0, end: 1.0).animate(animation);
            return FadeTransition(opacity: fadeAnimation, child: child);
          },
        ),
      );
    }
    if (index == 1) {
      setState(() {
        _selectedIndex = 1;
      });
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => ParentTrackMyBusScreen(driverId: driver!["id"].toString(), type: 'DRIVER',),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            var fadeAnimation = Tween(begin: 1.0, end: 1.0).animate(animation);
            return FadeTransition(opacity: fadeAnimation, child: child);
          },
        ),
      );
    }
    if (index == 2) {
      setState(() {
        _selectedIndex = 2;
      });
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => DriverChatScreen(vehicleId: driver!["vehicleId"].toString(), driverId: driver!["id"].toString()),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            var fadeAnimation = Tween(begin: 1.0, end: 1.0).animate(animation);
            return FadeTransition(opacity: fadeAnimation, child: child);
          },
        ),
      );
    }
    if (index == 3) {
      setState(() {
        _selectedIndex = 3;
      });
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => DriverProfileScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            var fadeAnimation = Tween(begin: 1.0, end: 1.0).animate(animation);
            return FadeTransition(opacity: fadeAnimation, child: child);
          },
        ),
      );
    }
  }


  @override
  void initState() {
    setState(() {
      getUser();
      _selectedIndex = widget.selectedScreen;
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    if (_isLoading || driver == null) {
      return Center(child: CircularProgressIndicator());
    }

    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.grey,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: "Home",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.directions_bus),
          label: "Location",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.chat),
          label: "Chat",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: "Profile",
        ),
      ],
    );
  }

}
