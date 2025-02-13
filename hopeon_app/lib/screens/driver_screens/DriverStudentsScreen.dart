import 'package:flutter/material.dart';
import 'package:hopeon_app/screens/common_screens/StudentInfoScreen.dart';
import 'package:hopeon_app/screens/driver_screens/DriverAttendanceScreen.dart';
import 'package:hopeon_app/services/schedule_service.dart';

class DriverStudentsScreen extends StatefulWidget {
  final String vehicleId;

  const DriverStudentsScreen(
      {super.key, required this.vehicleId});

  @override
  State<DriverStudentsScreen> createState() =>
      _DriverStudentsScreenState();
}

class _DriverStudentsScreenState extends State<DriverStudentsScreen> {
  List<dynamic> students = [];

  final ScheduleService _scheduleService = ScheduleService();
  bool _isLoading = false;

  void _loadAttendance() async {
    setState(() {
      _isLoading = true;
    });

    Map<String, dynamic> res = await _scheduleService.getAttendance(
        widget.vehicleId, DateTime.now().toIso8601String().split("T")[0], "TO_SCHOOL");
    if (res['success']) {
      setState(() {
        students = res['body'];
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
    _loadAttendance();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.fromLTRB(0, 30, 0, 10),
          child: Text("Student List",
              style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
        ),
        backgroundColor: Colors.blue,
      ),
      body: _isLoading
          ? const Center(
        child: CircularProgressIndicator(color: Colors.blue),
      )
          : students.isEmpty
          ? const Center(
          child: Text(
            "No students",
            style: TextStyle(fontSize: 18),
          ))
          : ListView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: students.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: ListTile(
              style: ListTileStyle.list,
              leading: CircleAvatar(
                radius: 25,
                backgroundImage: AssetImage(
                    "assets/images/profile-parent.png"),
              ),
              title: Text(
                students[index]["fullName"] + " ("+students[index]["grade"]+" - "+students[index]["studentClass"]+")",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                "Reg No: "+students[index]["regNo"],
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.grey[600]),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => StudentInfoScreen(id: students[index]["id"].toString())),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
