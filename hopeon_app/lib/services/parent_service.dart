import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class ParentService{
  final String baseUrl = "http://13.61.16.165:8080/api/v1/student";

  Future<Map<String, dynamic>?> getStudent(String id) async {
    final url = Uri.parse("$baseUrl/findById?id=$id");
    try {
      final response = await http.get(
        url,
        headers: {"Content-Type": "application/json"}
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data["status"] == 200 && data["object"] != null) {
          final user = data["object"];
          return user;
        }
      }
      return null;
    } catch (e) {
      print("Login error: $e");
      return null;
    }
  }

  Future<Map<String, dynamic>> updateStudent(Map<String, dynamic> student) async {
    final url = Uri.parse(baseUrl);
    try {
      final response = await http.put(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(student),
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


}