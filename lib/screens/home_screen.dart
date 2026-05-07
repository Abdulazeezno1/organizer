import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:organizer/class/item.dart';

class HomeScreen extends ConsumerWidget {
  HomeScreen({super.key});

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final item = ref.read(itemProvider.notifier);
    final itemNotifier = ref.watch(itemProvider);

    return Scaffold(
      appBar: AppBar(title: Text("Organize")),
      body: itemNotifier.isEmpty
          ? Center(child: Text("HEllo"))
          : ListView.builder(
              itemCount: itemNotifier.length,
              itemBuilder: (context, index) {
                final item = itemNotifier[index];
                return ListTile(
                  title: Text(item.name),
                  subtitle: Text(item.description),
                  trailing: Text("₦${item.price}"),
                );
              },
            ),
      floatingActionButton: Builder(
        builder: (context) {
          return FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (context) {
                  return Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    height: 300,
                    child: Column(
                      spacing: 16,
                      children: [
                        TextFormField(
                          controller: titleController,
                          decoration: const InputDecoration(
                            labelText: "Enter item",
                            border: OutlineInputBorder(),
                          ),
                        ),
                        TextFormField(
                          controller: priceController,
                          decoration: const InputDecoration(
                            labelText: "Enter price",
                            border: OutlineInputBorder(),
                          ),
                        ),
                        TextFormField(
                          controller: descriptionController,
                          decoration: const InputDecoration(
                            labelText: "Enter decription",
                            border: OutlineInputBorder(),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            final name = titleController.text.trim();
                            final price = double.parse(
                              priceController.text.trim(),
                            );
                            final description = descriptionController.text
                                .trim();
                            item.addItem(
                              name: name,
                              price: price,
                              description: description,
                            );
                            Navigator.pop(context);
                          },
                          child: const Text("Save"),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
