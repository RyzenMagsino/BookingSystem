import 'package:flutter/material.dart';

class BookingDetailsScreen extends StatelessWidget {
  final String date;
  final String time;
  final String carType;
  final List<Map<String, dynamic>> services;
  final double total;

  const BookingDetailsScreen({
    Key? key,
    required this.date,
    required this.time,
    required this.carType,
    required this.services,
    required this.total,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF165661);

    const labelStyle = TextStyle(
      color: primaryColor,
      fontWeight: FontWeight.w600,
      fontSize: 16,
    );

    const valueStyle = TextStyle(
      color: Colors.black87,
      fontWeight: FontWeight.w500,
      fontSize: 16,
    );

    return Center(
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.75,
          padding: const EdgeInsets.only(top: 22, bottom: 22),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back button
              Padding(
                padding: const EdgeInsets.only(left: 20, bottom: 18),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: primaryColor),
                  iconSize: 26,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: () => Navigator.pop(context),
                ),
              ),

              _infoRow('Car Type:', carType, labelStyle, valueStyle),
              const SizedBox(height: 10),
              _infoRow('Date:', date, labelStyle, valueStyle),
              const SizedBox(height: 10),
              _infoRow('Time:', time, labelStyle, valueStyle),

              const SizedBox(height: 18),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text('Services:', style: labelStyle),
              ),
              const SizedBox(height: 10),

              ...services.map((service) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(service['name'] ?? '', style: valueStyle),
                    Text('${service['price'].toStringAsFixed(2)}', style: valueStyle),
                  ],
                ),
              )),

              const SizedBox(height: 18),
              const Divider(thickness: 1, color: Colors.grey),
              const SizedBox(height: 12),

              _infoRow(
                'Total:',
                '₱${total.toStringAsFixed(2)}',
                labelStyle.copyWith(fontSize: 17),
                valueStyle.copyWith(fontWeight: FontWeight.bold, fontSize: 17),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value, TextStyle labelStyle, TextStyle valueStyle) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: labelStyle),
          Text(value, style: valueStyle),
        ],
      ),
    );
  }
}
