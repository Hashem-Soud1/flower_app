import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/flower.dart';
import '../models/order_model.dart';
import '../providers/flower_provider.dart';

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
          trailing: isAdminView
              ? Text(
                  order.userEmail.split('@').first,
                  style: const TextStyle(color: Colors.grey),
                )
              : null,
        );
      },
    );
  }
}
