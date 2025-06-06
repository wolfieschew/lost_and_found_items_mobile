class User {
  final int? id;
  final String? name;
  final String email;
  final String? phone; // Tambahkan field phone
  final String? token;

  User({
    this.id,
    this.name,
    required this.email,
    this.phone, // Tambahkan parameter phone
    this.token,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'] ?? '',
      phone: json['phone'], // Parse phone dari JSON
      token: json['token'],
    );
  }
}
