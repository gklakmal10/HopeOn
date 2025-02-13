import 'package:flutter/material.dart';
import 'package:hopeon_app/services/parent_service.dart';

class StudentInfoScreen extends StatefulWidget {
  final String id;

  const StudentInfoScreen({super.key, required this.id});

  @override
  State<StudentInfoScreen> createState() => _StudentInfoScreenState();
}

class _StudentInfoScreenState extends State<StudentInfoScreen> {
  final ParentService _parentService = ParentService();
  late Map<String, dynamic>? student;
  bool _isLoading = false;

  void _loadStudentData() async {
    setState(() {
      _isLoading = true;
    });
    Map<String, dynamic>? fetchUser =
        await _parentService.getStudent(widget.id);
    if (fetchUser != null) {
      setState(() {
        student = fetchUser;
        _isLoading = false;
      });
    } else {
      student = null;
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    _loadStudentData();
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
          "Student Info",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Colors.blue),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // Profile Image
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: NetworkImage(
                              "https://www.w3schools.com/howto/img_avatar.png"), // Replace with actual image URL
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
                          infoText("Student Name", student?['fullName']),
                          infoText("Parent Name", student?['parentName']),
                          infoText("Contact Number", student?['contactNo']),
                          infoText("School", "WP/ Gankanda Central College"),
                          infoText("Grade",
                              student?['grade'] + " - " + student?['studentClass']),
                          infoText("Gender", student?['gender']),
                          infoText("Age", "${student!['age']} Years"),
                          infoText("Location", student?['location']),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
    );
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
