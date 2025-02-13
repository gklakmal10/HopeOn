import 'package:flutter/material.dart';
import 'package:hopeon_app/services/schedule_service.dart';
import 'package:table_calendar/table_calendar.dart';

class AttendanceMarkScreen extends StatefulWidget {
  final String id;

  const AttendanceMarkScreen({super.key, required this.id});

  @override
  _AttendanceMarkScreenState createState() => _AttendanceMarkScreenState();
}

class _AttendanceMarkScreenState extends State<AttendanceMarkScreen> {
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();

  bool _schoolAttendance = true;
  bool _homeAttendance = true;

  final ScheduleService _scheduleService = ScheduleService();
  bool _isLoading = false;

  List<dynamic> schedules = [];

  void _loadSchedules() async {
    setState(() {
      _isLoading = true;
    });
    Map<String, dynamic> res =
        await _scheduleService.getAllSchedules(widget.id);
    if (res['success']) {
      List<dynamic> fetchedSchedule = res['body'];
      Map<String, dynamic>? todaySchedule = fetchedSchedule.isNotEmpty
          ? fetchedSchedule
              .where((s) =>
                  s['date'] == _selectedDay.toIso8601String().split("T")[0])
              .toList()[0]
          : null;
      setState(() {
        schedules = fetchedSchedule;
        _isLoading = false;
        _schoolAttendance =
            todaySchedule != null ? todaySchedule['toSchool'] : true;
        _homeAttendance =
            todaySchedule != null ? todaySchedule['toHome'] : true;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _handleSelectDate(DateTime date) async {
    List<dynamic>? selectedSchedule = schedules.isNotEmpty
        ? schedules
            .where((s) => s['date'] == date.toIso8601String().split("T")[0])
            .toList()
        : null;
    if (selectedSchedule != null && selectedSchedule.isNotEmpty) {
      setState(() {
        _schoolAttendance = selectedSchedule[0]['toSchool'];
        _homeAttendance = selectedSchedule[0]['toHome'];
      });
    }else{
      setState(() {
        _schoolAttendance = true;
        _homeAttendance = true;
      });
    }
  }

  void _handleSaveSchedule() async {
    Map<String, dynamic> newSchedule = {
      "date": _selectedDay.toIso8601String().split("T")[0],
      "toHome": _homeAttendance,
      "toSchool": _schoolAttendance,
      "studentId":widget.id
    };

    Map<String, dynamic> res = await _scheduleService.saveSchedule(newSchedule);

    if(res['success']){
      _loadSchedules();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(res['message'])),
      );
    }else{
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(res['message'])),
      );
    }

  }

  @override
  void initState() {
    _loadSchedules();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Attendance Mark"),
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
              firstDay: DateTime.now(),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              onDaySelected: (selectedDay, focusedDay) {
                _handleSelectDate(selectedDay);
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
            RadioListTile<bool>(
              title: const Text("Yes, I will come today."),
              value: true,
              groupValue: _schoolAttendance,
              onChanged: (value) => setState(() => _schoolAttendance = value!),
            ),
            RadioListTile<bool>(
              title: const Text("No, I will not come today."),
              value: false,
              groupValue: _schoolAttendance,
              onChanged: (value) => setState(() => _schoolAttendance = value!),
            ),
            const SizedBox(height: 10),
            const Text("To Home",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            RadioListTile<bool>(
              title: const Text("Yes, I will come today."),
              value: true,
              groupValue: _homeAttendance,
              onChanged: (value) => setState(() => _homeAttendance = value!),
            ),
            RadioListTile<bool>(
              title: const Text("No, I will not come today."),
              value: false,
              groupValue: _homeAttendance,
              onChanged: (value) => setState(() => _homeAttendance = value!),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                ),
                onPressed: _handleSaveSchedule,
                child: const Text("Submit",
                    style: TextStyle(fontSize: 16, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
