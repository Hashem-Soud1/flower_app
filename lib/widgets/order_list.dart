import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/flower.dart';
import '../models/order_model.dart';
import '../providers/flower_provider.dart';
import '../providers/auth_provider.dart';

class OrderList extends StatelessWidget {
  final List<OrderModel> orders;
  final bool isAdminView;

  const OrderList({super.key, required this.orders, this.isAdminView = false});

  @override
  Widget build(BuildContext context) {
    if (orders.isEmpty) {
      return const Center(
        child: Text("No orders found", style: TextStyle(color: Colors.grey)),
      );
    }

    final flowerProvider = Provider.of<FlowerProvider>(context, listen: false);

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: orders.length,
      separatorBuilder: (ctx, i) => const Divider(),
      itemBuilder: (context, index) {
        final order = orders[index];
        final flower = flowerProvider.flowers.cast<Flower?>().firstWhere(
          (f) => f?.id == order.flowerId,
          orElse: () => null,
        );

        return ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.grey[200],
              image: flower != null && flower.imageUrl.isNotEmpty
                  ? DecorationImage(
                      image: CachedNetworkImageProvider(flower.imageUrl),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: flower == null
                ? const Icon(Icons.shopping_bag, color: Colors.grey)
                : null,
          ),
          title: Text(
            isAdminView ? order.userName : (flower?.name ?? "Unknown Flower"),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            "${DateFormat.yMMMd().format(order.orderDate)} • \$${order.totalPrice.toStringAsFixed(2)}",
            style: const TextStyle(color: Colors.grey),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isAdminView)
                Text(
                  order.userEmail.split('@').first,
                  style: const TextStyle(color: Colors.grey),
                ),
              IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.red),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text("Delete Order"),
                      content: const Text(
                        "Are you sure you want to delete this order?",
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx),
                          child: const Text("Cancel"),
                        ),
                        TextButton(
                          onPressed: () async {
                            final auth = Provider.of<AuthProvider>(
                              context,
                              listen: false,
                            );
                            Navigator.pop(ctx);
                            await flowerProvider.deleteOrder(
                              order.orderId,
                              auth.user?.uid,
                              isAdminView,
                            );
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Order deleted")),
                              );
                            }
                          },
                          child: const Text(
                            "Delete",
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
