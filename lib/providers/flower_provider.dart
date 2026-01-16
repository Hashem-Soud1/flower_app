import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/flower.dart';
import '../models/order_model.dart';

class FlowerProvider with ChangeNotifier {
  List<Flower> flowers = [];
  List<OrderModel> userOrders = [];
  List<OrderModel> adminOrders = [];
  bool isLoading = false;

  Future<void> fetchFlowers() async {
    isLoading = true;
    notifyListeners();

    var snapshot = await FirebaseFirestore.instance.collection('flowers').get();
    flowers = snapshot.docs
        .map((doc) => Flower.fromMap(doc.data(), doc.id))
        .toList();

    isLoading = false;
    notifyListeners();
  }

  Future<void> addFlower(Flower flower) async {
    await FirebaseFirestore.instance.collection('flowers').add(flower.toMap());
    fetchFlowers();
  }

  Future<void> updateFlower(Flower flower) async {
    await FirebaseFirestore.instance
        .collection('flowers')
        .doc(flower.id)
        .update(flower.toMap());
    fetchFlowers();
  }

  Future<void> deleteFlower(String id) async {
    await FirebaseFirestore.instance.collection('flowers').doc(id).delete();
    fetchFlowers();
  }

  Future<void> placeOrder(OrderModel order) async {
    await FirebaseFirestore.instance.collection('orders').add(order.toMap());
  }

  Future<void> fetchUserOrders(String userId) async {
    isLoading = true;
    notifyListeners();

    var snapshot = await FirebaseFirestore.instance
        .collection('orders')
        .where('userId', isEqualTo: userId)
        .get();

    userOrders = snapshot.docs
        .map((doc) => OrderModel.fromMap(doc.data(), doc.id))
        .toList();
    userOrders.sort((a, b) => b.orderDate.compareTo(a.orderDate));

    isLoading = false;
    notifyListeners();
  }

  Future<void> fetchAdminOrders() async {
    isLoading = true;
    notifyListeners();

    var snapshot = await FirebaseFirestore.instance.collection('orders').get();
    adminOrders = snapshot.docs
        .map((doc) => OrderModel.fromMap(doc.data(), doc.id))
        .toList();
    adminOrders.sort((a, b) => b.orderDate.compareTo(a.orderDate));

    isLoading = false;
    notifyListeners();
  }

  Future<void> deleteOrder(String orderId, String? userId, bool isAdmin) async {
    await FirebaseFirestore.instance.collection('orders').doc(orderId).delete();
    if (isAdmin) {
      await fetchAdminOrders();
    } else if (userId != null) {
      await fetchUserOrders(userId);
    }
  }
}
