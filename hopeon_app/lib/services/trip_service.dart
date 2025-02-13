import 'dart:convert';
import 'package:http/http.dart' as http;

class TripService {
  final String baseUrl = "http://13.61.16.165:8080/api/v1/trip";

  Future<Map<String, dynamic>> saveTrip(Map<String, dynamic> trip) async {
    final url = Uri.parse(baseUrl);
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(trip),
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
    } catch (e) {
      print("Login error: $e");
      return {
        "success": false,
      };
    }
  }

  Future<Map<String, dynamic>> findTrip(String driverId, String type, String date)async{
    final url = Uri.parse("$baseUrl?driverId=$driverId&type=$type&date=$date");

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

  Future<Map<String, dynamic>> markPickUp(String attendanceId)async{
    final url = Uri.parse("$baseUrl?attendanceId=$attendanceId");

    try{
      final response = await http.put(
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

  Future<Map<String, dynamic>> endTrip(String id)async{
    final url = Uri.parse("$baseUrl/endTrip?id=$id");

    try{
      final response = await http.put(
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
