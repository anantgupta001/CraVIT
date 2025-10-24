import 'package:cloud_firestore/cloud_firestore.dart';

class AppOrder {
  final String id;
  final String userId;
  final String vendorId;
  final String status;
  final double amount;
  final Timestamp createdAt;
  final List<Map<String, dynamic>> items;

  AppOrder({
    required this.id,
    required this.userId,
    required this.vendorId,
    required this.status,
    required this.amount,
    required this.createdAt,
    required this.items,
  });

  factory AppOrder.fromJson(Map<String, dynamic> json) {
    return AppOrder(
      id: json['id'] as String,
      userId: json['userId'] as String,
      vendorId: json['vendorId'] as String,
      status: json['status'] as String,
      amount: (json['amount'] as num).toDouble(),
      createdAt: json['createdAt'] as Timestamp,
      items: List<Map<String, dynamic>>.from(json['items'] as List<dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'vendorId': vendorId,
      'status': status,
      'amount': amount,
      'createdAt': createdAt,
      'items': items,
    };
  }
}
