import 'package:cloud_firestore/cloud_firestore.dart';

class ReportModel {
  const ReportModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.phone,
    required this.address,
    required this.city,
    required this.reportDate,
    required this.violationCategories,
    required this.localImagePath,
    required this.status,
    required this.latitude,
    required this.longitude,
    required this.createdAt,
  });

  final String id;
  final String userId;
  final String name;
  final String phone;
  final String address;
  final String city;
  final String reportDate;
  final List<String> violationCategories;
  final String localImagePath;
  final String status;
  final double latitude;
  final double longitude;
  final DateTime createdAt;

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'name': name,
      'phone': phone,
      'address': address,
      'city': city,
      'reportDate': reportDate,
      'violationCategories': violationCategories,
      'localImagePath': localImagePath,
      'status': status,
      'latitude': latitude,
      'longitude': longitude,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  factory ReportModel.fromDocument(DocumentSnapshot<Map<String, dynamic>> doc) {
    final Map<String, dynamic> data = doc.data() ?? <String, dynamic>{};

    return ReportModel(
      id: doc.id,
      userId: data['userId'] as String? ?? '',
      name: data['name'] as String? ?? '',
      phone: data['phone'] as String? ?? '',
      address: data['address'] as String? ?? '',
      city: data['city'] as String? ?? '',
      reportDate: data['reportDate'] as String? ?? '',
      violationCategories: List<String>.from(
        data['violationCategories'] as List<dynamic>? ?? <dynamic>[],
      ),
      localImagePath: data['localImagePath'] as String? ?? '',
      status: data['status'] as String? ?? 'Tersimpan',
      latitude: (data['latitude'] as num?)?.toDouble() ?? 0,
      longitude: (data['longitude'] as num?)?.toDouble() ?? 0,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
}
