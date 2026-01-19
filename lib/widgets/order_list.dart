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

    final flowerProvider = context.read<FlowerProvider>();

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

        return Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 0),
          child: Row(
            children: [
              // Image
              Container(
                width: 70,
                height: 70,
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
              const SizedBox(width: 12),

              // Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isAdminView
                          ? order.userName
                          : (flower?.name ?? "Unknown Flower"),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      DateFormat.yMMMd().format(order.orderDate),
                      style: const TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                    if (isAdminView) ...[
                      const SizedBox(height: 4),
                      Text(
                        order.userEmail,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                    const SizedBox(height: 8),
                    // Price and Quantity Info
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green[50],
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: Colors.green[200]!),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "الكمية: ${order.quantity}",
                            style: TextStyle(
                              color: Colors.green[700],
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Container(
                            width: 1,
                            height: 16,
                            color: Colors.green[200],
                          ),
                          const SizedBox(width: 12),
                          Text(
                            "\$${order.totalPrice.toStringAsFixed(2)}",
                            style: TextStyle(
                              color: Colors.green[700],
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Delete Button
              IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.red),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text("حذف الطلب"),
                      content: const Text(
                        "هل أنت متأكد من رغبتك في حذف هذا الطلب؟",
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx),
                          child: const Text("إلغاء"),
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
                                const SnackBar(content: Text("تم حذف الطلب")),
                              );
                            }
                          },
                          child: const Text(
                            "حذف",
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
