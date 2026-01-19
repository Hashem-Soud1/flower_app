import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/flower.dart';
import '../providers/auth_provider.dart';
import '../providers/flower_provider.dart';
import '../widgets/flower_card.dart';
import 'manage_flower_dialog.dart';
import 'details_screen.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    final flowerProvider = context.watch<FlowerProvider>();
    final isAdmin = context.watch<AuthProvider>().isAdmin;
    final flowers = flowerProvider.flowers;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Flower Shop",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
      ),
      floatingActionButton: isAdmin
          ? FloatingActionButton(
              backgroundColor: Colors.green,
              child: const Icon(Icons.add, color: Colors.white),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (ctx) => const ManageFlowerDialog(),
                ).then((value) {
                  if (value != null) {
                    context.read<FlowerProvider>().addFlower(value);
                  }
                });
              },
            )
          : null,
      body: flowerProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () => flowerProvider.fetchFlowers(),
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: flowers.length,
                itemBuilder: (context, index) {
                  final flower = flowers[index];
                  return FlowerCard(
                    flower: flower,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => DetailsScreen(flower: flower),
                        ),
                      );
                    },
                    onEdit: () {
                      showDialog(
                        context: context,
                        builder: (ctx) => ManageFlowerDialog(flower: flower),
                      ).then((value) {
                        if (value != null) {
                          final updated = Flower(
                            id: flower.id,
                            name: value.name,
                            description: value.description,
                            price: value.price,
                            imageUrl: value.imageUrl,
                            category: value.category,
                          );
                          context.read<FlowerProvider>().updateFlower(updated);
                        }
                      });
                    },
                    onDelete: () {
                      context.read<FlowerProvider>().deleteFlower(flower.id);
                    },
                  );
                },
              ),
            ),
    );
  }
}
