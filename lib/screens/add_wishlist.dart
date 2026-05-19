import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:organizer/class/item.dart';

class AddWishlist extends ConsumerStatefulWidget {
  const AddWishlist({super.key});

  @override
  ConsumerState<AddWishlist> createState() => _AddWishlistState();
}

class _AddWishlistState extends ConsumerState<AddWishlist> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final item = ref.read(itemProvider.notifier);

    return Builder(
      builder: (scaffoldContext) {
        return FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            showModalBottomSheet(
              context: scaffoldContext,
              isScrollControlled: true,
              builder: (sheetContext) {
                String? priceError;
                int selectedPriority = 5;

                return StatefulBuilder(
                  builder: (context, setSheetState) {
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
                                          setSheetState(() {
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

                                      setSheetState(() {
                                        selectedPriority = value;
                                      });
                                    },
                                    trailingIcon: const Icon(
                                      Icons.keyboard_arrow_down_sharp,
                                      size: 20,
                                    ),
                                    selectedTrailingIcon: const Icon(
                                      Icons.keyboard_arrow_up_sharp,
                                      size: 20,
                                    ),
                                  ),
                                ],
                              ),

                              TextFormField(
                                keyboardType: TextInputType.multiline,
                                controller: descriptionController,
                                maxLines: null,
                                decoration: const InputDecoration(
                                  labelText: "Enter description",
                                  border: OutlineInputBorder(),
                                ),
                              ),

                              ElevatedButton(
                                onPressed: () {
                                  final name = titleController.text.trim();
                                  final description = descriptionController.text
                                      .trim();

                                  final price = double.tryParse(
                                    priceController.text.trim(),
                                  );

                                  if (price == null) {
                                    setSheetState(() {
                                      priceError = "The price is not a number";
                                    });

                                    return;
                                  }

                                  item.addItem(
                                    id: DateTime.now().microsecondsSinceEpoch
                                        .toString(),
                                    name: name,
                                    price: price,
                                    description: description,
                                    priority: selectedPriority,
                                    isPurchased: false,
                                    dateAdded: DateTime.now(),
                                  );

                                  titleController.clear();
                                  priceController.clear();
                                  descriptionController.clear();

                                  Navigator.pop(sheetContext);
                                },
                                child: const Text("Save"),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }
}
