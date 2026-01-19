import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/flower_provider.dart';
import '../widgets/order_list.dart';

class AdminOrdersScreen extends StatelessWidget {
  const AdminOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final orders = context.watch<FlowerProvider>().adminOrders;
    return Scaffold(
      appBar: AppBar(title: const Text("All Orders (Admin)")),
      body: OrderList(orders: orders, isAdminView: true),
    );
  }
}
