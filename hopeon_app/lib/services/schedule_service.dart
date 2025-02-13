import 'dart:convert';
import 'package:http/http.dart' as http;

class ScheduleService {
  final String baseUrl = "http://13.61.16.165:8080/api/v1";

  Future<Map<String, dynamic>> saveSchedule(Map<String, dynamic> schedule) async {
    final url = Uri.parse("$baseUrl/schedule");
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(schedule),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data["status"] == 200) {
          return {"success": true, "message":data['message']};
        }
      }
      if (response.statusCode == 400) {
        final data = jsonDecode(response.body);

        if (data["status"] == 400) {
          return {"success": false, "message": data['message']};
        }
      }
      return {
        "success": false,
      };
    } catch (e) {
      print("Login error: $e");
      return {
        "success": false,
      };
    }
  }

  Future<Map<String, dynamic>> getAllSchedules(String studentId)async{
    final url = Uri.parse("$baseUrl/schedule?studentId=$studentId");

    try{
      final response = await http.get(
        url,
        headers: {"Content-Type": "application/json"}
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data["status"] == 200) {
          return {"success": true, "body":data['object']};
        }
      }
      if (response.statusCode == 400) {
        final data = jsonDecode(response.body);

        if (data["status"] == 400) {
          return {"success": false, "message": data['message']};
        }
      }
      return {
        "success": false,
      };
    }catch(e){
      return {
        "success": false,
        "message":e
      };
    }
  }

  Future<Map<String, dynamic>> getAttendance(String vehicleId, String date, String type)async{
    final url = Uri.parse("$baseUrl/vehicle/getStudentAttendance?date=$date&vehicleId=$vehicleId&type=$type");

    try{
      final response = await http.get(
          url,
          headers: {"Content-Type": "application/json"}
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data["status"] == 200) {
          return {"success": true, "body":data['object']};
        }
      }
      if (response.statusCode == 400) {
        final data = jsonDecode(response.body);

        if (data["status"] == 400) {
          return {"success": false, "message": data['message']};
        }
      }
      return {
        "success": false,
      };
    }catch(e){
      return {
        "success": false,
        "message":e
      };
    }
  }

}
