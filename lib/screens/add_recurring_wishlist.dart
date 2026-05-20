import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salaryplan/class/recurring_expense.dart';

class AddRecurringWishlist extends ConsumerStatefulWidget {
  const AddRecurringWishlist({super.key});

  @override
  ConsumerState<AddRecurringWishlist> createState() =>
      _AddRecurringWishlistState();
}

class _AddRecurringWishlistState extends ConsumerState<AddRecurringWishlist> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  String? priceError;
  int selectedFrequency = 1;

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final recurringItem = ref.read(recurringItemProvider.notifier);

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
              const Text(
                "Add Recurring Item",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

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
                    label: const Text("Frequency"),
                    initialSelection: selectedFrequency,
                    dropdownMenuEntries: const [
                      DropdownMenuEntry(label: "Weekly", value: 0),
                      DropdownMenuEntry(label: "Monthly", value: 1),
                    ],
                    onSelected: (value) {
                      if (value == null) return;

                      setState(() {
                        selectedFrequency = value;
                      });
                    },
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
                  final description = descriptionController.text.trim();

                  final price = double.tryParse(priceController.text.trim());

                  if (price == null) {
                    setState(() {
                      priceError = "The price is not a number";
                    });

                    return;
                  }

                  final frequency = selectedFrequency == 0
                      ? Frequency.weekly
                      : Frequency.monthly;

                  recurringItem.addItems(
                    DateTime.now().microsecondsSinceEpoch.toString(),
                    name,
                    price,
                    frequency,
                    description,
                    DateTime.now(),
                  );

                  Navigator.pop(context);
                },
                child: const Text("Save"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
