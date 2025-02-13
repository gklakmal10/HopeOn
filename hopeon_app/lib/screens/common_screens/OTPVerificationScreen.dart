import 'package:flutter/material.dart';
import 'package:hopeon_app/screens/common_screens/ResetPasswordScreen.dart';
import 'package:hopeon_app/services/auth_service.dart';

class OTPVerificationScreen extends StatefulWidget {
  final String email;
  final String type;
  OTPVerificationScreen({super.key, required this.email, required this.type});

  @override
  State<OTPVerificationScreen> createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
  final List<TextEditingController> otpControllers =
  List.generate(4, (index) => TextEditingController());
  final AuthService _authService = AuthService();
  bool _isLoading = false;
  String? _errorMessage;

  void _handleVerifyOTP() async {
    setState(() {
      _errorMessage = null;
    });

    String otp = otpControllers.map((controller) => controller.text).join();

    if (otp.length < 4 || otp.contains(RegExp(r'[^0-9]'))) {
      setState(() {
        _errorMessage = "Please enter a valid 4-digit OTP.";
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    bool isValid = await _authService.verifyOTP(widget.email, otp);

    setState(() {
      _isLoading = false;
    });

    if (isValid) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ResetPasswordScreen(email: widget.email, type:widget.type)),
      );
    } else {
      setState(() {
        _errorMessage = "Invalid OTP. Please try again.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "Verification",
              style: TextStyle(
                fontSize: 35,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "We have sent OTP to your e-mail,\nplease type code in here",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                4,
                    (index) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: SizedBox(
                    width: 50,
                    child: TextField(
                      controller: otpControllers[index],
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      maxLength: 1,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Color.fromRGBO(210, 230, 255, 1),
                        counterText: "",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onChanged: (value) {
                        if (value.isNotEmpty && index < 3) {
                          FocusScope.of(context).nextFocus();
                        }
                      },
                    ),
                  ),
                ),
              ),
            ),
            if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: MaterialButton(
                padding: const EdgeInsets.all(10),
                color: const Color.fromRGBO(37, 100, 255, 1.0),
                onPressed: _isLoading ? null : _handleVerifyOTP,
                minWidth: 300,
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Continue",
                    style: TextStyle(fontSize: 20, color: Colors.white)),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Didn’t receive OTP?"),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    "Resend OTP",
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
