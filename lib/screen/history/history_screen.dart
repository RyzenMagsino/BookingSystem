import 'package:flutter/material.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.4),
                offset: const Offset(0, 5),
                blurRadius: 6,
              ),
            ],
          ),
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0, // remove default shadow
            title: Text(
              'E&C\nCarwash',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins', // <- Now using Poppins
                color: Colors.blue[400],
                height: 1.2,
                shadows: [
                  const Shadow(
                    offset: Offset(3, 3),
                    blurRadius: 2,
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.menu, color: Colors.black),
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),

      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0f9ba8), Color(0xFF00344d)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          top: false, // we already have an AppBar
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12.0),
                child: Text(
                  'History',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [Shadow(blurRadius: 2, offset: Offset(1, 1))],
                  ),
                ),
              ),

              // History Cards
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: 2,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.teal,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            offset: const Offset(2, 3),
                            blurRadius: 4,
                          )
                        ],
                      ),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Date:', style: TextStyle(color: Colors.white)),
                              Text('05/27/2025', style: TextStyle(color: Colors.white)),
                            ],
                          ),
                          SizedBox(height: 6),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Car Type:', style: TextStyle(color: Colors.white)),
                              Text('Sedan', style: TextStyle(color: Colors.white)),
                            ],
                          ),
                          SizedBox(height: 6),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Total:', style: TextStyle(color: Colors.white)),
                              Text('290.00', style: TextStyle(color: Colors.white)),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              // Bottom Navigation
              Padding(
                padding: const EdgeInsets.only(bottom: 12, top: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildNavButton(context, 'Home', false),
                    _buildNavButton(context, 'Pending', false),
                    _buildNavButton(context, 'History', true),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavButton(BuildContext context, String title, bool isActive) {
    return ElevatedButton(
      onPressed: () {
        // Handle navigation
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: isActive ? Colors.tealAccent : Colors.white,
        foregroundColor: Colors.black,
        shadowColor: Colors.black,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      child: Text(title),
    );
  }
}