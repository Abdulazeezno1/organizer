import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salaryplan/class/salary_entry.dart';

class AddSalary extends ConsumerStatefulWidget {
  const AddSalary({super.key});

  @override
  ConsumerState<AddSalary> createState() => _AddSalaryState();
}

class _AddSalaryState extends ConsumerState<AddSalary> {
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController amountController = TextEditingController();

  String? amountError;
  int selectedPriority = 5;

  @override
  void dispose() {
    descriptionController.dispose();
    amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final salaryNotifier = ref.watch(salaryProvider.notifier);

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
                "Add Salary",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

              TextFormField(
                controller: amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Enter price",
                  border: const OutlineInputBorder(),
                  errorText: amountError,
                ),
                onChanged: (value) {
                  if (amountError != null) {
                    setState(() {
                      amountError = null;
                    });
                  }
                },
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
                  final description = descriptionController.text.trim();

                  final amount = double.tryParse(amountController.text.trim());

                  if (amount == null) {
                    setState(() {
                      amountError = "The amount is not a number";
                    });

                    return;
                  }

                  salaryNotifier.addSalary(
                    id: DateTime.now().microsecondsSinceEpoch.toString(),
                    amount: amount,
                    description: description,
                    date: DateTime.now(),
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
