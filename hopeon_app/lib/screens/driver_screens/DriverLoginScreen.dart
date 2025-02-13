import 'package:flutter/material.dart';
import 'package:hopeon_app/screens/common_screens/ForgotPasswordScreen.dart';
import 'package:hopeon_app/screens/driver_screens/DriverDashboardScreen.dart';
import 'package:hopeon_app/screens/parent_screens/ParentDashboardScreen.dart';
import 'package:hopeon_app/services/auth_service.dart';

class DriverLoginScreen extends StatefulWidget {
  const DriverLoginScreen({Key? key}) : super(key: key);

  @override
  _DriverLoginScreenState createState() => _DriverLoginScreenState();
}

class _DriverLoginScreenState extends State<DriverLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService();

  bool _isLoading = false;

  void _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      bool success = await _authService.login(
          _emailController.text.trim(),
          _passwordController.text.trim(),
          "DRIVER"
      );

      setState(() => _isLoading = false);

      if (success) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const DriverDashboardScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Invalid email or password")),
        );
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          // Wrap the content with SingleChildScrollView
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                const SizedBox(height: 40),
                Image.asset(
                  "assets/images/driver_login.png",
                  width: 300, // Set a reasonable width
                  height: 300, // Set a reasonable height
                ),
                const SizedBox(height: 20),
                const Text(
                  "Welcome Back",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                ),
                const SizedBox(height: 20),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // Email Field
                      SizedBox(
                        width: 300, // Set text field width to 300
                        child: TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            prefixIcon: const Icon(Icons.email), // Start icon
                            border: OutlineInputBorder(
                              // Full border
                              borderRadius: BorderRadius.circular(10),
                            ),
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
                      const SizedBox(height: 20),

                      // Password Field
                      SizedBox(
                        width: 300, // Set text field width to 300
                        child: TextFormField(
                          controller: _passwordController,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            prefixIcon: const Icon(Icons.lock), // Start icon
                            border: OutlineInputBorder(
                              // Full border
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          obscureText: true, // Hide password text
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            if (value.length < 6) {
                              return 'Password must be at least 6 characters';
                            }
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 10, 40, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            GestureDetector( child: const Text("Forgot Password", style: TextStyle(color: Colors.blue),), onTap: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                    const ForgotPasswordScreen(type: "DRIVER",)),
                              );
                            },),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),
                      MaterialButton(
                        onPressed: _handleLogin,
                        minWidth: 300,
                        color: Color.fromRGBO(58, 89, 243, 1),
                        child: _isLoading
                            ? const CircularProgressIndicator() : const Text(
                          "Log In",
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

      ),
    );
  }
}
