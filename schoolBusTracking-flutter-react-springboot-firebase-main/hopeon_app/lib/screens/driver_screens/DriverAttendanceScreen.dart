import 'package:flutter/material.dart';
import 'package:hopeon_app/screens/driver_screens/ToHomeAttendanceScreen.dart';
import 'package:hopeon_app/screens/driver_screens/ToSchoolAttendanceScreen.dart';
import 'package:table_calendar/table_calendar.dart';

class DriverAttendanceScreen extends StatefulWidget {
  final String vehicleId;

  const DriverAttendanceScreen({super.key, required this.vehicleId});

  @override
  _DriverAttendanceScreenState createState() => _DriverAttendanceScreenState();
}

class _DriverAttendanceScreenState extends State<DriverAttendanceScreen> {
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Attendance Details"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TableCalendar(
              firstDay: DateTime.utc(DateTime.now().year - 1, 01, 01),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              },
              calendarStyle: CalendarStyle(
                selectedDecoration: const BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
                todayDecoration: BoxDecoration(
                  color: Colors.blue.shade200,
                  shape: BoxShape.circle,
                ),
              ),
              headerStyle: const HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
              ),
            ),
            const SizedBox(height: 20),
            const Text("To School",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            MaterialButton(
              padding: const EdgeInsets.all(10),
              color: const Color.fromRGBO(37, 100, 255, 1.0),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ToSchoolAttendanceScreen(
                            vehicleId: widget.vehicleId,
                            date: _selectedDay.toIso8601String().split("T")[0],
                          )),
                );
              },
              minWidth: 300,
              child: const Text("View Attendence",
                  style: TextStyle(fontSize: 16, color: Colors.white)),
            ),
            const SizedBox(height: 30),
            const Text("To Home",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            MaterialButton(
              padding: const EdgeInsets.all(10),
              color: const Color.fromRGBO(37, 100, 255, 1.0),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ToHomeAttendanceScreen(
                          vehicleId: widget.vehicleId,
                          date: _selectedDay.toIso8601String().split("T")[0])),
                );
              },
              minWidth: 300,
              child: const Text("View Attendence",
                  style: TextStyle(fontSize: 16, color: Colors.white)),
            )
          ],
        ),
      ),
    );
  }
}
