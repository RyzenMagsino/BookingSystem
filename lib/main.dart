// main.dart
import 'package:booking/screen/booking/car_selection.dart';
import 'package:booking/screen/booking/customer_form.dart';
import 'package:booking/screen/home/home_screen.dart';
import 'package:booking/screen/pending/pending_screen.dart';
import 'package:booking/screen/profile/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:booking/screen/auth/login_screen.dart';
import 'package:booking/screen/auth/signup_screen.dart';
import 'package:booking/screen/auth/ChangePass.dart';
import 'package:booking/screen/booking/ServiceType.dart';
import 'package:booking/screen/booking/confirmation.dart';
import 'package:booking/screen/history/history_screen.dart';
import 'package:booking/models/booking.dart';
import 'package:booking/screen/history/historydetails.dart';


void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
        ),
      ),

      initialRoute: '/login',
      routes: {
        '/login':      (_) => const LoginPage(),
        '/home':       (_) => const HomeScreen(),
        '/signup':     (_) => const SignUpScreen(),
        '/changePass': (_) => const ChangePasswordScreen(),
        '/services':   (_) => const ServicesScreen(),
        '/history':    (_) => const HistoryScreen(),
        '/pending':    (_) => const PendingScreen(),
        '/cars':       (_) => const CarSelectionScreen(),
        '/customer':   (_) => const CustomerFormScreen(),
        '/profile':    (_) => const ProfileScreen(),
        '/historyd':    (_) => const BookingDetailsScreen(date: '', carType: '', total: '',),


        '/confirmation': (context) {
          final args = ModalRoute.of(context)!.settings.arguments;
          if (args is Booking) {
            return ConfirmationScreen(booking: args);
          } else {
            // Prevent crash by redirecting or showing error
            return const Scaffold(
              body: Center(child: Text("Booking data not found")),
            );
          }
        },




      },
    );
  }
}
