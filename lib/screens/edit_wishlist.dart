import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salaryplan/class/item.dart';

class EditWishlist extends ConsumerStatefulWidget {
  const EditWishlist({super.key, required this.item});

  final Item item;

  @override
  ConsumerState<EditWishlist> createState() => _EditWishlistState();
}

class _EditWishlistState extends ConsumerState<EditWishlist> {
  late final TextEditingController titleController;
  late final TextEditingController descriptionController;
  late final TextEditingController priceController;

  String? priceError;
  late int selectedPriority;

  @override
  void initState() {
    super.initState();

    titleController = TextEditingController(text: widget.item.name);
    descriptionController = TextEditingController(
      text: widget.item.description ?? "",
    );
    priceController = TextEditingController(text: widget.item.price.toString());

    selectedPriority = widget.item.priority;
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final itemNotifier = ref.read(itemProvider.notifier);

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 16,
            children: [
              TextFormField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: "Enter item",
                  border: OutlineInputBorder(),
                ),
              ),

              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: priceController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: "Enter price",
                        border: const OutlineInputBorder(),
                        errorText: priceError,
                      ),
                      onChanged: (value) {
                        if (priceError != null) {
                          setState(() {
                            priceError = null;
                          });
                        }
                      },
                    ),
                  ),

                  const SizedBox(width: 12),

                  DropdownMenu<int>(
                    label: const Text("Priority"),
                    initialSelection: selectedPriority,
                    dropdownMenuEntries: const [
                      DropdownMenuEntry(label: "5", value: 5),
                      DropdownMenuEntry(label: "4", value: 4),
                      DropdownMenuEntry(label: "3", value: 3),
                      DropdownMenuEntry(label: "2", value: 2),
                      DropdownMenuEntry(label: "1", value: 1),
                    ],
                    onSelected: (value) {
                      if (value == null) return;

                      setState(() {
                        selectedPriority = value;
                      });
                    },
                  ),
                ],
              ),

              TextFormField(
                controller: descriptionController,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: const InputDecoration(
                  labelText: "Enter description",
                  border: OutlineInputBorder(),
                ),
              ),

              ElevatedButton(
                onPressed: () {
                  final name = titleController.text.trim();
                  final description = descriptionController.text.trim();

                  final price = double.tryParse(priceController.text.trim());

                  if (price == null) {
                    setState(() {
                      priceError = "The price is not a number";
                    });

                    return;
                  }

                  itemNotifier.editItem(
                    id: widget.item.id,
                    name: name,
                    price: price,
                    description: description,
                    priority: selectedPriority,
                    isPurchased: widget.item.isPurchased,
                  );

                  Navigator.pop(context);
                },
                child: const Text("Save Changes"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
