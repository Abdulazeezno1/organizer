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

  late Frequencies selectedPayCycle;
  String? amountError;

  @override
  void initState() {
    super.initState();

    selectedPayCycle = widget.salary.payCycle;

    descriptionController = TextEditingController(
      text: widget.salary.description ?? "",
    );

    amountController = TextEditingController(
      text: widget.salary.amount.toString(),
    );
  }

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
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 16,
            children: [
              Center(
                child: Container(
                  width: 42,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
              ),

              const SizedBox(height: 4),

              Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: Colors.green.withOpacity(0.12),
                    child: const Icon(Icons.edit, color: Colors.green),
                  ),

                  const SizedBox(width: 12),

                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Edit Salary",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          "Update your salary amount or pay cycle.",
                          style: TextStyle(color: Colors.grey, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              TextFormField(
                controller: amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Salary amount",
                  prefixText: "₦ ",
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

              const Text(
                "Pay Cycle",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),

              SizedBox(
                width: double.infinity,
                child: SegmentedButton<Frequencies>(
                  segments: const [
                    ButtonSegment(
                      value: Frequencies.monthly,
                      label: Text("Monthly"),
                      icon: Icon(Icons.calendar_month),
                    ),
                    ButtonSegment(
                      value: Frequencies.weekly,
                      label: Text("Weekly"),
                      icon: Icon(Icons.calendar_view_week),
                    ),
                  ],
                  selected: {selectedPayCycle},
                  onSelectionChanged: (value) {
                    setState(() {
                      selectedPayCycle = value.first;
                    });
                  },
                ),
              ),

              TextFormField(
                controller: descriptionController,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: const InputDecoration(
                  labelText: "Description",
                  hintText: "Optional note",
                  border: OutlineInputBorder(),
                ),
              ),

              ElevatedButton.icon(
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
                    payCycle: selectedPayCycle,
                    date: widget.salary.date,
                  );

                  Navigator.pop(context);
                },
                icon: const Icon(Icons.save),
                label: const Text("Save Changes"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
