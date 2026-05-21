import 'package:flutter/material.dart';
import 'package:salaryplan/class/recurring_expense.dart';
import 'package:salaryplan/class/salary_entry.dart';
import 'package:salaryplan/widget/add_salary.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salaryplan/widget/show_item_to_buy.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recurringItems = ref.watch(recurringItemProvider);
    final salaryNotifier = ref.watch(salaryProvider);

    final monthlyExpenses = calculateTotalExpenses(
      recurringItems,
      Frequency.monthly,
    );

    final weeklyExpenses = calculateTotalExpenses(
      recurringItems,
      Frequency.weekly,
    );
    return Scaffold(
      appBar: AppBar(title: Text("SalaryPlan"), centerTitle: true),
      body: salaryNotifier.isEmpty
          ? const Center(
              child: Text(
                "Add your salary to see recommendations",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            )
          : const Padding(padding: EdgeInsets.all(16), child: ShowItemToBuy()),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (context) {
              return const AddSalary();
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
