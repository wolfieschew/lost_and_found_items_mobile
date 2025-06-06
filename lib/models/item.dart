// lib/models/item.dart
class Item {
  final int id;
  final String type; // hilang/ditemukan
  final String itemName;
  final String category;
  final DateTime dateOfEvent;
  final String description;
  final String email;
  final String phoneNumber;
  final String location;
  final String? photoPath;
  final String status;
  final String reportBy;
  final String createdAt;

  Item({
    required this.id,
    required this.type,
    required this.itemName,
    required this.category,
    required this.dateOfEvent,
    required this.description,
    required this.email,
    required this.phoneNumber,
    required this.location,
    this.photoPath,
    required this.status,
    required this.reportBy,
    required this.createdAt,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    // Handle nested contact_info object
    Map<String, dynamic> contactInfo = json['contact_info'] ?? {};

    return Item(
      id: json['id'],
      type: json['type'] ?? '',
      itemName: json['item_name'] ?? '',
      category: json['category'] ?? '',
      dateOfEvent:
          json['date_of_event'] != null
              ? DateTime.parse(json['date_of_event'])
              : DateTime.now(),
      description: json['description'] ?? '',
      email: contactInfo['email'] ?? json['email'] ?? '',
      phoneNumber: contactInfo['phone_number'] ?? json['phone_number'] ?? '',
      location: json['location'] ?? '',
      photoPath: json['photo_url'] ?? json['photo_path'],
      status: json['status'] ?? 'pending',
      reportBy: contactInfo['report_by'] ?? json['report_by'] ?? '',
      createdAt: json['created_at'] ?? '',
    );
  }

  // Helper method to get display image URL
  String get displayImageUrl {
    if (photoPath == null) return '';
    // Check if photoPath is already a full URL
    if (photoPath!.startsWith('http')) {
      return photoPath!;
    }
    // Adjust based on your Laravel storage configuration
    return 'http://127.0.0.1:8000/storage/$photoPath';
  }

  // Helper method to get formatted date
  String get formattedDate {
    return "${dateOfEvent.day}-${dateOfEvent.month}-${dateOfEvent.year}";
  }

  // Helper getter to return a readable status
  String get statusDisplay {
    switch (status) {
      case 'pending':
        return 'Menunggu';
      case 'approved':
        return 'Disetujui';
      case 'rejected':
        return 'Ditolak';
      case 'claimed':
        return 'Diklaim';
      default:
        return status;
    }
  }
}
