class Booking {
  final String id;
  final String name;
  final String phone;
  final String carType;
  final String plate;
  final String date;
  final String time;
  final List<Map<String, dynamic>> services;

  Booking({
    required this.id,
    required this.name,
    required this.phone,
    required this.carType,
    required this.plate,
    required this.date,
    required this.time,
    required this.services,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['_id'],
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      carType: json['carType'] ?? '',
      plate: json['plate'] ?? '',
      date: json['date'] ?? '',
      time: json['time'] ?? '',
      services: List<Map<String, dynamic>>.from(json['services']),
    );
  }
}
