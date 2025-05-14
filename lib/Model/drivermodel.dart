class Driver {
  final int id;
  final String email;
  final String phone;
  final String image;

  Driver({
    required this.id,
    required this.email,
    required this.phone,
    required this.image,
  });

  factory Driver.fromJson(Map<String, dynamic> json) {
    return Driver(
      id: json['driver_id'] ?? 0,
      email: json['email'] ?? 'N/A',
      phone: json['phone'] ?? 'N/A',
      image: json['image'] ?? 'https://example.com/default-image.png',
    );
  }

  Map<String, dynamic> toJson() {
    return {'driver_id': id, 'email': email, 'phone': phone, 'image': image};
  }
}
