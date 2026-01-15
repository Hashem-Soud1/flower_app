import 'package:flutter/material.dart';
import '../models/flower.dart';

class ManageFlowerDialog extends StatefulWidget {
  final Flower? flower;

  const ManageFlowerDialog({super.key, this.flower});

  @override
  _ManageFlowerDialogState createState() => _ManageFlowerDialogState();
}

class _ManageFlowerDialogState extends State<ManageFlowerDialog> {
  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  final _priceController = TextEditingController();
  final _imageController = TextEditingController();
  final _categoryController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.flower != null) {
      _nameController.text = widget.flower!.name;
      _descController.text = widget.flower!.description;
      _priceController.text = widget.flower!.price.toString();
      _imageController.text = widget.flower!.imageUrl;
      _categoryController.text = widget.flower!.category;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.flower == null ? "Add Flower" : "Edit Flower"),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: "Name",
                prefixIcon: Icon(Icons.local_florist),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _descController,
              decoration: const InputDecoration(
                labelText: "Description",
                prefixIcon: Icon(Icons.description),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _priceController,
              decoration: const InputDecoration(
                labelText: "Price",
                prefixIcon: Icon(Icons.attach_money),
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _imageController,
              decoration: const InputDecoration(
                labelText: "Image URL",
                prefixIcon: Icon(Icons.image),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _categoryController,
              decoration: const InputDecoration(
                labelText: "Category",
                prefixIcon: Icon(Icons.category),
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: () {
            final flower = Flower(
              id: widget.flower?.id ?? '', // ID handled by DB for new
              name: _nameController.text,
              description: _descController.text,
              price: double.tryParse(_priceController.text) ?? 0.0,
              imageUrl: _imageController.text,
              category: _categoryController.text,
            );
            Navigator.pop(context, flower);
          },
          child: Text("Save"),
        ),
      ],
    );
  }
}
