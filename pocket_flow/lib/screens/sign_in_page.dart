// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:pocket_flow/services/api_services.dart';
import 'package:pocket_flow/widgets/bottom_navbar_widget.dart';
import 'package:pocket_flow/widgets/password_visiblility_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'sign_up_page.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String? _errorMessage;
  bool _obscurePassword = true;

  final ApiService _apiService = ApiService(); // Initialize ApiService
  // Sign in function

  Future<void> _signIn() async {
    final String email = _emailController.text;
    final String password = _passwordController.text;

    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF002D62)),
                ),
                SizedBox(height: 20),
                Text(
                  "Signing in...",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    try {
      final response = await _apiService.authenticateUser(email, password);

      if (response['message'] == "Authenticated successfully") {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);
        await _fetchUserIdByEmail(email); // Fetch userId by email

        // Add delay before navigation
        await Future.delayed(Duration(milliseconds: 1000));

        // Navigate to home page
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => BottomNavbarWidget()),
          );
        }
      } else {
        if (mounted) {
          Navigator.pop(context); // Close loading dialog
          setState(() {
            _errorMessage = 'Invalid email or password.';
          });
        }
      }
    } catch (error) {
      if (mounted) {
        Navigator.pop(context); // Close loading dialog
        setState(() {
          _errorMessage = 'Authentication failed. Please try again.';
        });
      }
    }
  }

  Future<void> _fetchUserIdByEmail(String email) async {
    try {
      final users = await _apiService.getAllUsers();
      final user = users.firstWhere(
        (user) => user['email'] == email,
        orElse: () => {},
      );

      if (user.isNotEmpty) {
        final userId = user['id'];

        // Store userId in SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setInt('userId', userId);

        // You can also return userId if you want to use it elsewhere
        return userId;
      } else {
        setState(() {
          _errorMessage = 'User not found.';
        });
      }
    } catch (error) {
      setState(() {
        _errorMessage = 'Failed to fetch user ID. Please try again.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 80),
                    Center(
                      child: Image.asset('assets/app/logo.png', height: 80),
                    ),
                    SizedBox(height: 32),
                    Text(
                      'Sign in',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 24),
                    Text('Email'),
                    SizedBox(height: 8),
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        hintText: 'Enter your email',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Email is required';
                        }
                        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                          return 'Enter a valid email';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 10),
                    Text('Password'),
                    SizedBox(height: 8),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        hintText: 'Enter your password',
                        border: OutlineInputBorder(),
                        suffixIcon: PasswordVisibility(
                          obscureText: _obscurePassword,
                          onVisibilityChanged: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Password is required';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 24),
                    if (_errorMessage != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text(
                          _errorMessage!,
                          style: TextStyle(color: Colors.red, fontSize: 14),
                        ),
                      ),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF002D62),
                          padding: EdgeInsets.all(10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _signIn(); // Call the sign-in function
                          }
                        },
                        child: Text(
                          'Sign in',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Don\'t have an account? ',
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SignUpPage()));
                          },
                          child: Text(
                            'Sign up.',
                            style: TextStyle(
                              color: Color(0xFF002D62),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
