import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OTPVerificationScreen extends StatefulWidget {
  final String email;

  const OTPVerificationScreen({Key? key, required this.email}) : super(key: key);

  @override
  State<OTPVerificationScreen> createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
  final TextEditingController _otpController = TextEditingController();
  bool _isLoading = false;

  Future<void> _verifyOTP() async {
    setState(() => _isLoading = true);

    try {
      final response = await http.post(
        Uri.parse('https://bookingbackend-1-uf30.onrender.com/api/auth/verify-otp'), // adjust IP for real device
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': widget.email.trim(),
        'otp': _otpController.text.trim(),
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        _showDialog('Success', data['message'] ?? 'Verified!');
        // Navigate to HomePage or LoginPage
        Navigator.pushReplacementNamed(context, '/login');
      } else {
        _showDialog('Error', data['message'] ?? 'Invalid OTP');
      }
    } catch (e) {
      _showDialog('Error', 'Something went wrong: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("OTP Verification")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const Text("Enter the OTP sent to your email"),
            const SizedBox(height: 20),
            TextField(
              controller: _otpController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "OTP Code"),
            ),
            const SizedBox(height: 20),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
              onPressed: _verifyOTP,
              child: const Text("Verify"),
            ),
          ],
        ),
      ),
    );
  }
}
