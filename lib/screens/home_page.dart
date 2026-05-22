import 'package:flutter/material.dart';
import 'package:salaryplan/class/history_entry.dart';
import 'package:salaryplan/class/recurring_expense.dart';
import 'package:salaryplan/class/salary_entry.dart';
import 'package:salaryplan/widget/add_salary.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salaryplan/widget/show_item_to_buy.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyItems = ref.watch(historyProvider);
    final recurringItems = ref.watch(recurringItemProvider);
    final salaries = ref.watch(salaryProvider);

    if (salaries.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text("SalaryPlan"), centerTitle: true),
        body: const Center(
          child: Text(
            "Add your salary to see recommendations",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
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
          child: const Icon(Icons.add),
        ),
      );
    }

    final latestSalary = salaries.last;

    final boughtAfterSalary = historyItems.where((historyItem) {
      return historyItem.dateBought.isAfter(latestSalary.date);
    }).toList();

    final totalBought = boughtAfterSalary.fold<double>(
      0,
      (sum, item) => sum + item.price,
    );

    final monthlyExpenses = calculateTotalExpenses(
      recurringItems,
      Frequency.monthly,
    );

    final salary = latestSalary.amount;

    final availableMoney = salary - monthlyExpenses - totalBought;

    return Scaffold(
      appBar: AppBar(title: const Text("SalaryPlan"), centerTitle: true),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _SummaryRow(title: "Salary", amount: salary),
                    const SizedBox(height: 8),
                    _SummaryRow(
                      title: "Recurring Expenses",
                      amount: monthlyExpenses,
                    ),
                    const SizedBox(height: 8),
                    _SummaryRow(
                      title: "Bought This Cycle",
                      amount: totalBought,
                    ),
                    const Divider(),
                    _SummaryRow(
                      title: "Available Balance",
                      amount: availableMoney,
                      isBold: true,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            const Expanded(child: ShowItemToBuy()),
          ],
        ),
      ),

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
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.title,
    required this.amount,
    this.isBold = false,
  });

  final String title;
  final double amount;
  final bool isBold;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
          ),
        ),
        Text(
          "₦${amount.toStringAsFixed(2)}",
          style: TextStyle(
            fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
