import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salaryplan/class/salary_entry.dart';

class EditSalary extends ConsumerStatefulWidget {
  const EditSalary({super.key, required this.salary});
  final SalaryEntry salary;

  @override
  ConsumerState<EditSalary> createState() => _EditSalaryState();
}

class _EditSalaryState extends ConsumerState<EditSalary> {
  late final TextEditingController descriptionController;
  late final TextEditingController amountController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    descriptionController = TextEditingController(
      text: widget.salary.description,
    );
    amountController = TextEditingController(
      text: widget.salary.amount.toString(),
    );
  }

  String? amountError;

  @override
  void dispose() {
    descriptionController.dispose();
    amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final salaryNotifier = ref.read(salaryProvider.notifier);

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
                "Edit Salary",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

              TextFormField(
                controller: amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Enter salary amount",
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

                  salaryNotifier.editSalary(
                    id: widget.salary.id,
                    amount: amount,
                    description: description,
                    date: widget.salary.date,
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
