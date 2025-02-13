import 'package:flutter/material.dart';
import 'package:hopeon_app/screens/driver_screens/DriverAttendanceScreen.dart';
import 'package:hopeon_app/services/schedule_service.dart';

class ToHomeAttendanceScreen extends StatefulWidget {
  final String vehicleId;
  final String date;
  const ToHomeAttendanceScreen({super.key, required this.vehicleId, required this.date});

  @override
  State<ToHomeAttendanceScreen> createState() =>
      _ToHomeAttendanceScreenState();
}

class _ToHomeAttendanceScreenState extends State<ToHomeAttendanceScreen> {

  List<dynamic> students = [];

  final ScheduleService _scheduleService = ScheduleService();
  bool _isLoading = false;

  void _loadAttendance() async {
    setState(() {
      _isLoading = true;
    });

    Map<String, dynamic> res = await _scheduleService.getAttendance(
        widget.vehicleId, widget.date, "TO_HOME");
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
          child: Text("To Home Attendance - September 24",
              style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => DriverAttendanceScreen(vehicleId: widget.vehicleId,)),
            )
          },
        ),
        backgroundColor: Colors.blue,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: students.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(10.0),

            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 25,
                      backgroundImage: AssetImage("assets/images/profile-parent.png"),
                    ),
                    const SizedBox(width: 20,),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(students[index]["fullName"] + " ("+students[index]["grade"]+" - "+students[index]["studentClass"]+")"),
                        Text("Reg No: "+students[index]["regNo"]),
                      ],
                    ),
                  ],
                ),
                Switch(value: students[index]["attendance"], onChanged: (value) => {}, )
              ],
            ),
          );
        },
      ),
    );
  }
}
