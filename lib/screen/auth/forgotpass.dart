import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isEmailValid = true;
  String? _emailError;
  bool _isLoading = false;

  final RegExp emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

  Future<void> _sendResetLink() async {
    setState(() => _isLoading = true);

    final url = Uri.parse('https://bookingbackend-1-uf30.onrender.com/api/user/forgot-password');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': _emailController.text}),
    );

    setState(() => _isLoading = false);
    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      Navigator.pushNamed(
        context,
        '/verify-otp',
        arguments: {'email': _emailController.text},
      );
    } else {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Error'),
          content: Text(data['message'] ?? 'Something went wrong.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF008C9E), Color(0xFF003C4D)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: SafeArea(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'E&C',
                  style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const Text(
                  'CARWASH',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const SizedBox(height: 30),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white70, width: 2),
                  ),
                  child: const Icon(Icons.lock_outline, size: 40, color: Colors.white),
                ),
                const SizedBox(height: 30),
                const Text(
                  'Trouble logging in?',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Enter your email and we'll send you a link to get back into your account.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
                const SizedBox(height: 30),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: _isEmailValid ? Colors.transparent : Colors.red,
                      width: 1.5,
                    ),
                  ),
                  child: TextFormField(
                    controller: _emailController,
                    style: const TextStyle(color: Colors.white),
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      hintText: 'Enter your email',
                      hintStyle: TextStyle(color: Colors.white70),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        setState(() {
                          _isEmailValid = false;
                          _emailError = 'Email is required';
                        });
                        return '';
                      } else if (!emailRegex.hasMatch(value)) {
                        setState(() {
                          _isEmailValid = false;
                          _emailError = 'Enter a valid email address';
                        });
                        return '';
                      }
                      setState(() {
                        _isEmailValid = true;
                        _emailError = null;
                      });
                      return null;
                    },
                  ),
                ),
                if (_emailError != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        _emailError!,
                        style: const TextStyle(color: Colors.red, fontSize: 12),
                      ),
                    ),
                  ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading
                        ? null
                        : () {
                      if (_formKey.currentState!.validate()) {
                        _sendResetLink();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('Send login link', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: const [
                    Expanded(child: Divider(color: Colors.white38)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text('OR', style: TextStyle(color: Colors.white70)),
                    ),
                    Expanded(child: Divider(color: Colors.white38)),
                  ],
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () => Navigator.pushNamed(context, '/signup'),
                  child: const Text('Create new account', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Back to login', style: TextStyle(color: Colors.white70)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
