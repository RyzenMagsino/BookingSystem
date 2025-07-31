import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../screen/history/historydetails.dart';
import '../../models/booking_model.dart';
import 'package:shared_preferences/shared_preferences.dart';


class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<Booking> bookings = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchBookings();
  }

  Future<void> fetchBookings() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.get(
      Uri.parse('https://bookingbackend-1-uf30.onrender.com/api/book/my-bookings'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        bookings = data.map((json) => Booking.fromJson(json)).toList();
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      debugPrint('Failed to load bookings: ${response.body}');

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: const Color(0xFF2299A2),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 4,
        title: const Text(
          'E&C\nCarwash',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            fontFamily: 'Cinzel',
            color: Color(0xFF006B79),
            height: 1.1,
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/profile');
            },
            child: const Padding(
              padding: EdgeInsets.only(right: 16),
              child: CircleAvatar(
                backgroundImage: NetworkImage('https://www.example.com/your-profile-image.jpg'),
                radius: 18,
              ),
            ),
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.black87),
            onSelected: (value) {
              if (value == 'logout') {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text("Logout"),
                    content: const Text("Are you sure you want to logout?"),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("Cancel"),
                      ),
                      TextButton(
                        onPressed: () async {
                          final prefs = await SharedPreferences.getInstance();
                          await prefs.clear();
                          Navigator.pushNamedAndRemoveUntil(context, '/login', (_) => false);
                        },
                        child: const Text("Logout", style: TextStyle(color: Colors.red)),
                      ),
                    ],
                  ),
                );
              }
            },
            offset: const Offset(0, 50),
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem(
                value: 'logout',
                child: Center(child: Text('Logout', style: TextStyle(color: Colors.red))),
              ),
            ],
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.white))
          : Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF2299A2), Color(0xFF1F7E90)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 10, bottom: 20),
                child: Center(
                  child: Text(
                    'History',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: bookings.isEmpty
                    ? const Center(child: Text('No bookings found', style: TextStyle(color: Colors.white)))
                    : ListView.builder(
                  itemCount: bookings.length,
                  itemBuilder: (context, index) {
                    final booking = bookings[index];
                    final total = booking.services.fold<double>(
                      0,
                          (sum, service) => sum + ((service['price'] ?? 0) as num).toDouble(),
                    );

                    return GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (_) => Center(
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 30),
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 10,
                                    offset: Offset(0, 4),
                                  )
                                ],
                              ),
                              height: 450,
                              child: BookingDetailsScreen(
                                date: booking.date,
                                time: booking.time,
                                carType: booking.carType,
                                services: List<Map<String, dynamic>>.from(booking.services),
                                total: total,
                              ),

                            ),
                          ),
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF165661),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _infoRow('Date:', booking.date),
                            _infoRow('Car Type:', booking.carType),
                            _infoRow('Total:', total.toStringAsFixed(2)
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _navPill('Home', onTap: () => Navigator.pushNamed(context, '/home')),
                  _navPill('Pending', onTap: () => Navigator.pushNamed(context, '/pending')),
                  _navPill('History', isActive: true, onTap: () {}),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.white)),
          Text(value, style: const TextStyle(color: Colors.white)),
        ],
      ),
    );
  }

  Widget _navPill(String label, {bool isActive = false, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF00D6C6) : const Color(0xFF88D4DB),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            shadows: [Shadow(offset: Offset(2, 2), blurRadius: 2, color: Colors.black54)],
          ),
        ),
      ),
    );
  }
}
