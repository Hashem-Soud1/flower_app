import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/flower.dart';
import '../models/order_model.dart';
import '../providers/auth_provider.dart';
import '../providers/flower_provider.dart';

class DetailsScreen extends StatelessWidget {
  final Flower flower;

  const DetailsScreen({super.key, required this.flower});

  void _placeOrder(BuildContext context) async {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final flowerProvider = Provider.of<FlowerProvider>(context, listen: false);
    final user = auth.user;

    if (user == null) return;

    final order = OrderModel(
      orderId: '',
      flowerId: flower.id,
      userId: user.uid,
      userName: user.displayName ?? 'User',
      userEmail: user.email ?? '',
      totalPrice: flower.price,
      orderDate: DateTime.now(),
    );

    await flowerProvider.placeOrder(order);
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Order placed successfully!")),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(flower.name)),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 250,
              width: double.infinity,
              child: Hero(
                tag: flower.id,
                child: CachedNetworkImage(
                  imageUrl: flower.imageUrl,
                  fit: BoxFit.cover,
                  placeholder: (ctx, url) => Container(color: Colors.grey[200]),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "\$${flower.price.toStringAsFixed(2)}",
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(flower.category),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Description",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    flower.description,
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(
          left: 20,
          right: 20,
          bottom: 40,
          top: 10,
        ),
        child: ElevatedButton(
          onPressed: () => _placeOrder(context),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          child: const Text("Place Order"),
        ),
      ),
    );
  }
}
