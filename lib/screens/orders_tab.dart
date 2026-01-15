import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/flower_provider.dart';
import '../widgets/order_list.dart';

class OrdersTab extends StatelessWidget {
  const OrdersTab({super.key});

  @override
  Widget build(BuildContext context) {
    final flowerProvider = Provider.of<FlowerProvider>(context);
    final auth = Provider.of<AuthProvider>(context);
    final isAdmin = auth.isAdmin;

    final orders = isAdmin
        ? flowerProvider.adminOrders
        : flowerProvider.userOrders;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isAdmin ? "All Orders" : "My Orders",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
      ),
      body: flowerProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () async {
                if (isAdmin) {
                  await flowerProvider.fetchAdminOrders();
                } else if (auth.user != null) {
                  await flowerProvider.fetchUserOrders(auth.user!.uid);
                }
              },
              child: OrderList(orders: orders, isAdminView: isAdmin),
            ),
    );
  }
}
