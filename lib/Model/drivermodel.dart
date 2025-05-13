class Driver {
  final int id;
  final String username;
  final String email;
  final String phone;
  final String image;
  final String token;

  Driver({
    required this.id,
    required this.username,
    required this.email,
    required this.phone,
    required this.image,
    required this.token,
  });

  factory Driver.fromJson(Map<String, dynamic> json) {
    return Driver(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      phone: json['phone'],
      image: json['image'],
      token: json['token'],
    );
  }
}
