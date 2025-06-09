class User {
  final int? id;
  final String? name; // Tetap pertahankan field name untuk kompatibilitas
  final String email;
  final String? phone;
  final String? firstName; // Tambahkan field baru
  final String? lastName; // Tambahkan field baru
  final String? nim;
  final String? address;
  final String? role;
  final String? profilePicture;
  final String? token;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  User({
    this.id,
    this.name,
    required this.email,
    this.phone,
    this.firstName,
    this.lastName,
    this.nim,
    this.address,
    this.role,
    this.profilePicture,
    this.token,
    this.createdAt,
    this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'] ?? '',
      phone: json['phone'],
      firstName: json['first_name'], // Pastikan key sesuai dengan response API
      lastName: json['last_name'], // Pastikan key sesuai dengan response API
      nim: json['nim'],
      address: json['address'],
      role: json['role'],
      profilePicture: json['profile_picture'],
      token: json['token'],
      createdAt:
          json['created_at'] != null
              ? DateTime.parse(json['created_at'])
              : null,
      updatedAt:
          json['updated_at'] != null
              ? DateTime.parse(json['updated_at'])
              : null,
    );
  }

  // Pastikan getter fullName menangani null dengan benar
  String get fullName {
    if (firstName != null || lastName != null) {
      return '${firstName ?? ''} ${lastName ?? ''}'.trim();
    }
    return name ?? '';
  }
}
