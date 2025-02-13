import 'dart:convert';
import 'package:http/http.dart' as http;

class AlertService {
  final String baseUrl = "http://13.61.16.165:8080/api/v1/alert";

  Future<Map<String, dynamic>> saveAlert(String message, String driverId) async {
    final url = Uri.parse("$baseUrl?message=$message&driverId=$driverId");
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"}
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

  Future<Map<String, dynamic>> getAllAlerts(String driverId)async{
    final url = Uri.parse("$baseUrl?driverId=$driverId");

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
