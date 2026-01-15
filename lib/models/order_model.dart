import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModel {
  final String orderId;
  final String flowerId;
  final String userId;
  final String userName;
  final String userEmail;
  final double totalPrice;
  final DateTime orderDate;

  OrderModel({
    required this.orderId,
    required this.flowerId,
    required this.userId,
    required this.userName,
    required this.userEmail,
    required this.totalPrice,
    required this.orderDate,
  });

  factory OrderModel.fromMap(Map<String, dynamic> data, String docId) {
    return OrderModel(
      orderId: docId,
      flowerId: data['flowerId'] ?? '',
      userId: data['userId'] ?? '',
      userName: data['userName'] ?? '',
      userEmail: data['userEmail'] ?? '',
      totalPrice: (data['totalPrice'] ?? 0.0).toDouble(),
      orderDate: (data['orderDate'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'flowerId': flowerId,
      'userId': userId,
      'userName': userName,
      'userEmail': userEmail,
      'totalPrice': totalPrice,
      'orderDate': Timestamp.fromDate(orderDate),
    };
  }
}
