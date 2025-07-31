import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'otp_verification_screen.dart';


class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _isPressed = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  String? _validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) return '$fieldName is required';
    return null;
  }

  String? _validateUsername(String? value) {
    if (value == null || value.isEmpty) return 'Username is required';
    if (value.length < 4) return 'Username must be at least 4 characters';
    if (value.length > 20) return 'Username must be less than 20 characters';
    if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(value)) {
      return 'Username can only contain letters, numbers and underscore';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Email is required';
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) return 'Enter a valid email';
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Password is required';
    if (value.length < 6) return 'Password must be at least 6 characters';
    if (!RegExp(r'[A-Z]').hasMatch(value)) return 'Include at least one uppercase letter';
    if (!RegExp(r'[a-z]').hasMatch(value)) return 'Include at least one lowercase letter';
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value != _passwordController.text) return 'Passwords do not match';
    return null;
  }
  void _showDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          )
        ],
      ),
    );
  }


  void _handleSignUp() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isPressed = true);

      try {
        final response = await http.post(
          Uri.parse('https://bookingbackend-1-uf30.onrender.com/api/auth/signup'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'firstName': _firstNameController.text.trim(),
            'lastName': _lastNameController.text.trim(),
            'username': _usernameController.text.trim(),
            'phone': _phoneController.text.trim(),
            'email': _emailController.text.trim(),
            'password': _passwordController.text.trim(),
          }),
        );

        final data = jsonDecode(response.body);

        if (response.statusCode == 201) {
          if (data['message'] == 'Verification required') {
            final email = _emailController.text.trim(); // ✅ Save email before clearing
            print('✅ Sending email to OTP screen: $email');

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => OTPVerificationScreen(email: email),
              ),
            ).then((_) {
              // ✅ Clear fields AFTER navigation
              _firstNameController.clear();
              _lastNameController.clear();
              _usernameController.clear();
              _phoneController.clear();
              _emailController.clear();
              _passwordController.clear();
              _confirmPasswordController.clear();
            });
          } else {
            _showDialog('Success', data['message'] ?? 'Registration successful');
          }
        } else {
          _showDialog('Error', data['message'] ?? 'Registration failed');
        }
      } catch (e) {
        print('❌ Registration error: $e');
        _showDialog('Error', 'An error occurred. Please try again.');
      }
    }
  }



  Widget _buildTextField({
    required String hint,
    required TextEditingController controller,
    required String? Function(String?) validator,
    bool isPassword = false,
    bool? obscureText,
    VoidCallback? onToggleObscure,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText ?? isPassword,
      style: const TextStyle(color: Colors.white),
      validator: validator,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white70),
        filled: true,
        fillColor: Colors.white.withOpacity(0.2),
        contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: BorderSide.none,
        ),
        errorStyle: const TextStyle(color: Colors.redAccent),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: const BorderSide(color: Colors.redAccent),
        ),
        suffixIcon: isPassword
            ? IconButton(
          icon: Icon(
            obscureText ?? true ? Icons.visibility_off : Icons.visibility,
            color: Colors.white70,
          ),
          onPressed: onToggleObscure,
        )
            : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0f9ba8), Color(0xFF00344d)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'E&C',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const Text(
                      'CARWASH',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 30),

                    // First & Last Name Row
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                            hint: 'First Name',
                            controller: _firstNameController,
                            validator: (v) => _validateRequired(v, "First Name"),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildTextField(
                            hint: 'Last Name',
                            controller: _lastNameController,
                            validator: (v) => _validateRequired(v, "Last Name"),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // Username
                    _buildTextField(
                      hint: 'Create Username',
                      controller: _usernameController,
                      validator: _validateUsername,
                    ),
                    const SizedBox(height: 14),

                    // Phone Number
                    _buildTextField(
                      hint: 'Phone Number',
                      controller: _phoneController,
                      validator: (v) => _validateRequired(v, "Phone Number"),
                    ),
                    const SizedBox(height: 14),

                    // Email
                    _buildTextField(
                      hint: 'Enter Email Address',
                      controller: _emailController,
                      validator: _validateEmail,
                    ),
                    const SizedBox(height: 14),

                    // Password
                    _buildTextField(
                      hint: 'Create Password',
                      controller: _passwordController,
                      validator: _validatePassword,
                      isPassword: true,
                      obscureText: _obscurePassword,
                      onToggleObscure: () => setState(() => _obscurePassword = !_obscurePassword),
                    ),
                    const SizedBox(height: 14),

                    // Confirm Password
                    _buildTextField(
                      hint: 'Confirm Password',
                      controller: _confirmPasswordController,
                      validator: _validateConfirmPassword,
                      isPassword: true,
                      obscureText: _obscureConfirmPassword,
                      onToggleObscure: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                    ),
                    const SizedBox(height: 24),

                    // Sign Up Button
                    GestureDetector(
                      onTapDown: (_) => setState(() => _isPressed = true),
                      onTapUp: (_) {
                        setState(() => _isPressed = false);
                        _handleSignUp();
                      },
                      onTapCancel: () => setState(() => _isPressed = false),
                      child: AnimatedScale(
                        scale: _isPressed ? 0.95 : 1.0,
                        duration: const Duration(milliseconds: 100),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: Colors.black,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                offset: const Offset(0, 4),
                                blurRadius: 6,
                              ),
                            ],
                          ),
                          child: const Center(
                            child: Text(
                              'Sign Up',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 1,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => const LoginPage()),
                        );
                      },
                      child: const Text(
                        'Already have an account? LOGIN',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
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
