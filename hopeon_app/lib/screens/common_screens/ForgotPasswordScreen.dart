import 'package:flutter/material.dart';
import 'package:hopeon_app/screens/common_screens/OTPVerificationScreen.dart';
import 'package:hopeon_app/services/auth_service.dart';

class ForgotPasswordScreen extends StatefulWidget {
  final String type;
  const ForgotPasswordScreen({super.key, required this.type});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final AuthService _authService = AuthService();

  bool _isLoading = false;

  void _handleOTPSend() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      bool success =
          await _authService.sendOTPRequest(_emailController.text.trim(), widget.type);

      setState(() => _isLoading = false);

      if (success) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => OTPVerificationScreen(email: _emailController.text.trim(), type: widget.type,)),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Invalid email")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Forgot Password",
                style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 30,
              ),
              const Text("Please enter your email address",
                  style: TextStyle(fontSize: 20)),
              const Text("to receive a new OTP",
                  style: TextStyle(fontSize: 20)),
              const SizedBox(
                height: 20,
              ),
              Form(
                key: _formKey,
                child: TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!RegExp(
                            r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
                        .hasMatch(value)) {
                      return 'Enter a valid email';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              _isLoading
                  ? const CircularProgressIndicator()
                  : MaterialButton(
                      padding: const EdgeInsets.all(10),
                      color: const Color.fromRGBO(37, 100, 255, 1.0),
                      onPressed: _handleOTPSend,
                      minWidth: 300,
                      child: const Text("Continue",
                          style: TextStyle(fontSize: 20, color: Colors.white)),
                    ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Remember password?",
                      style: TextStyle(fontSize: 17)),
                  const SizedBox(
                    width: 10,
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      "Log In",
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
