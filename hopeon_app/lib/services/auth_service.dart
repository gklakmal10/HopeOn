import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final String baseUrl = "http://13.61.16.165:8080/api/v1";

  Future<bool> login(String email, String password, String type) async {
    final url = Uri.parse("$baseUrl/user/auth");
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": email,
          "password": password,
          "type": type
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data["status"] == 200 && data["object"] != null) {
          final user = data["object"];
          String userId = user['id'].toString();
          String userEmail = user['email'];
          String userType = user['type'];
          String fullName = user['fullName'];

          // Save credentials
          await saveUserCredentials(userId, userEmail, userType, fullName);
          return true;
        }
      }
      return false;
    } catch (e) {
      print("Login error: $e");
      return false;
    }
  }

  Future logOut()async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  Future<bool> sendOTPRequest(String email, String type)async{
    final url = Uri.parse("$baseUrl/mail/send-otp?email=$email&type=$type");
    try{
      final response = await http.get(
        url,
        headers: {"Content-Type": "application/json"},
      );
      if (response.statusCode == 200) {
        return true;
      }
      return false;
    }catch(e){
      if (kDebugMode) {
        print("Login error: $e");
      }
      return false;
    }
  }

  Future<bool> verifyOTP(String email, String otp)async{
    final url = Uri.parse("$baseUrl/mail/verify-otp?email=$email&otp=$otp");
    try{
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data["status"] == 200 && data["object"] == true) {
          return true;
        }
        return false;
      }
      return false;
    }catch(e){
      if (kDebugMode) {
        print("Login error: $e");
      }
      return false;
    }
  }

  Future<bool> resetPassword(String email, String password, String type) async {
    final url = Uri.parse("$baseUrl/user/reset-password");
    try {
      final response = await http.put(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": email,
          "newPassword": password,
          "type": type
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data["status"] == 200) {
          return true;
        }
      }
      return false;
    } catch (e) {
      print("Login error: $e");
      return false;
    }
  }

  Future saveUserCredentials(
      String userId, String email, String type, String fullName) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("user_id", userId);
    await prefs.setString("user_email", email);
    await prefs.setString("user_type", type);
    await prefs.setString("full_name", fullName);
  }
}
