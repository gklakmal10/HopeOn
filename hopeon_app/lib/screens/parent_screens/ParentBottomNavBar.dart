import 'package:flutter/material.dart';
import 'package:hopeon_app/screens/parent_screens/ParentChatScreen.dart';
import 'package:hopeon_app/screens/parent_screens/ParentDashboardScreen.dart';
import 'package:hopeon_app/screens/parent_screens/ParentProfileScreen.dart';
import 'package:hopeon_app/screens/parent_screens/ParentTrackMyBusScreen.dart';
import 'package:hopeon_app/services/parent_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ParentBottomNavBar extends StatefulWidget {
  final int selectedScreen;

  const ParentBottomNavBar({super.key, required this.selectedScreen});

  @override
  _ParentBottomNavBarState createState() => _ParentBottomNavBarState();
}

class _ParentBottomNavBarState extends State<ParentBottomNavBar> {
  late int _selectedIndex;

  void _onItemTapped(int index) {
    if (index == 0 && _selectedIndex != 0) {
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              ParentDashboardScreen(),
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
          pageBuilder: (context, animation, secondaryAnimation) =>
              ParentTrackMyBusScreen(driverId: student!['driverId'].toString(), type: "STUDENT",),
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
          pageBuilder: (context, animation, secondaryAnimation) =>
              ParentChatScreen(
            chatId: '',
            receiverName: student!['driverName'],
            senderId: student!['id'].toString(),
            receiverId: student!['driverId'].toString(),
            type: 'Student',
          ),
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
          pageBuilder: (context, animation, secondaryAnimation) =>
              const ParentProfileScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            var fadeAnimation = Tween(begin: 1.0, end: 1.0).animate(animation);
            return FadeTransition(opacity: fadeAnimation, child: child);
          },
        ),
      );
    }
  }

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
      });
    }
    setState(() {
      user = {
        "id": prefs.getString("user_id"),
        "email": prefs.getString("user_email"),
        "type": prefs.getString("user_type"),
        "fullName": prefs.getString("full_name"),
      };
      _isLoading = false;
    });
  }

  @override
  void initState() {
    getUser();
    setState(() {
      _selectedIndex = widget.selectedScreen;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
