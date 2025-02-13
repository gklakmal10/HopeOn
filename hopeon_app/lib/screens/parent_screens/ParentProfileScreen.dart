import 'package:flutter/material.dart';
import 'package:hopeon_app/screens/common_screens/GetStartScreen.dart';
import 'package:hopeon_app/screens/common_screens/OTPVerificationScreen.dart';
import 'package:hopeon_app/screens/parent_screens/EditStudentScreen.dart';
import 'package:hopeon_app/screens/parent_screens/ParentBottomNavBar.dart';
import 'package:hopeon_app/screens/parent_screens/ParentLoginScreen.dart';
import 'package:hopeon_app/services/auth_service.dart';
import 'package:hopeon_app/services/parent_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ParentProfileScreen extends StatefulWidget {
  const ParentProfileScreen({Key? key}) : super(key: key);

  @override
  State<ParentProfileScreen> createState() => _ParentProfileScreenState();
}

class _ParentProfileScreenState extends State<ParentProfileScreen> {
  final AuthService _authService = AuthService();
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
        user = {
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

  void _handleOTPSend() async {
    setState(() => _isLoading = true);

    bool success = await _authService.sendOTPRequest(user['email']!, "STUDENT");

    setState(() => _isLoading = false);

    if (success) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => OTPVerificationScreen(
                  email: user['email']!,
                  type: "STUDENT",
                )),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Invalid email")),
      );
    }
  }

  @override
  void initState() {
    getUser();
    super.initState();
  }

  void _showLogOutDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Log out"),
          backgroundColor: Colors.white,
          content: const Text(
            "Are you want to log out?",
            style: TextStyle(fontSize: 18),
          ),
          actions: [
            MaterialButton(
              color: Colors.grey[300],
              onPressed: () => Navigator.pop(context),
              child: const Text("No"),
            ),
            MaterialButton(
                color: Colors.red[400],
                child: const Text("Yes", style: TextStyle(color: Colors.white),),
                onPressed: () {
                  _authService.logOut();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const GetStartScreen()),
                  );
                })
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.blue,
              ),
            )
          : Center(
              child: Column(
                children: [
                  Container(
                      width: double.infinity,
                      color: const Color.fromRGBO(37, 100, 255, 1.0),
                      padding: const EdgeInsets.fromLTRB(30, 80, 10, 20),
                      child: const Text("Profile",
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white))),
                  const SizedBox(height: 50),
                  // Profile Image
                  CircleAvatar(
                    radius: 80,
                    backgroundImage: user["imageUrl"] != null
                        ? NetworkImage(user["imageUrl"]!)
                        : AssetImage(
                            "assets/images/profile-driver.png",
                          ),
                  ),
                  const SizedBox(height: 10),
                  // Student Name
                  Text(user['fullName']!,
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 80),
                  // Buttons
                  _buildButton("Edit Student details", () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              EditStudentScreen(id: user['id']!)),
                    );
                  }),
                  _buildButton("Reset Password", _handleOTPSend),
                  _buildButton("Log Out", () {
                    _showLogOutDialog();
                  }),
                ],
              ),
            ),
      bottomNavigationBar: ParentBottomNavBar(selectedScreen: 3),
    );
  }

  Widget _buildButton(String text, onPressed) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: MaterialButton(
        padding: EdgeInsets.all(10),
        color: const Color.fromRGBO(37, 100, 255, 1.0),
        onPressed: onPressed,
        minWidth: 300,
        child: Text(text,
            style: const TextStyle(fontSize: 16, color: Colors.white)),
      ),
    );
  }
}
