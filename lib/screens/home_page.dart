import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salaryplan/class/history_entry.dart';
import 'package:salaryplan/class/recurring_expense.dart';
import 'package:salaryplan/class/salary_entry.dart';
import 'package:salaryplan/widget/edit_salary.dart';
import 'package:salaryplan/widget/show_item_to_buy.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyItems = ref.watch(historyProvider);
    final recurringItems = ref.watch(recurringItemProvider);
    final salaries = ref.watch(salaryProvider);

    if (salaries.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundColor: Colors.green.withOpacity(0.12),
                    child: const Icon(
                      Icons.account_balance_wallet_outlined,
                      size: 34,
                      color: Colors.green,
                    ),
                  ),

                  const SizedBox(height: 16),

                  const Text(
                    "No salary added yet",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    "Add your salary to see buying recommendations.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
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

    final payCycleForExpenses = latestSalary.payCycle == Frequencies.weekly
        ? Frequency.weekly
        : Frequency.monthly;

    final recurringExpenses = calculateTotalExpenses(
      recurringItems,
      payCycleForExpenses,
    );

    final salary = latestSalary.amount;
    final availableMoney = salary - recurringExpenses - totalBought;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SalarySummaryCard(
            latestSalary: latestSalary,
            salary: salary,
            recurringExpenses: recurringExpenses,
            totalBought: totalBought,
            availableMoney: availableMoney,
          ),

          const SizedBox(height: 16),

          const Expanded(child: ShowItemToBuy()),
        ],
      ),
    );
  }
}

class _SalarySummaryCard extends StatelessWidget {
  const _SalarySummaryCard({
    required this.latestSalary,
    required this.salary,
    required this.recurringExpenses,
    required this.totalBought,
    required this.availableMoney,
  });

  final SalaryEntry latestSalary;
  final double salary;
  final double recurringExpenses;
  final double totalBought;
  final double availableMoney;

  String getCycle(Frequencies cycle) {
    if (cycle == Frequencies.monthly) {
      return "Monthly";
    }

    return "Weekly";
  }

  @override
  Widget build(BuildContext context) {
    final bool isNegative = availableMoney < 0;

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.green.withOpacity(0.12),
                  child: const Icon(
                    Icons.account_balance_wallet_outlined,
                    color: Colors.green,
                  ),
                ),

                const SizedBox(width: 12),

                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Current Salary Cycle",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        "Your active salary budget",
                        style: TextStyle(fontSize: 13, color: Colors.grey),
                      ),
                    ],
                  ),
                ),

                IconButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (context) {
                        return EditSalary(salary: latestSalary);
                      },
                    );
                  },
                  icon: const Icon(Icons.edit),
                ),
              ],
            ),

            const SizedBox(height: 18),

            _SummaryRow(
              title: "Salary",
              amount: salary,
              icon: Icons.payments_outlined,
            ),

            const SizedBox(height: 10),

            _InfoRow(
              title: "Pay Cycle",
              value: getCycle(latestSalary.payCycle),
              icon: latestSalary.payCycle == Frequencies.monthly
                  ? Icons.calendar_month
                  : Icons.calendar_view_week,
            ),

            const SizedBox(height: 10),

            _SummaryRow(
              title: "Recurring Expenses",
              amount: recurringExpenses,
              icon: Icons.repeat,
            ),

            const SizedBox(height: 10),

            _SummaryRow(
              title: "Bought This Cycle",
              amount: totalBought,
              icon: Icons.shopping_bag_outlined,
            ),

            const Divider(height: 28),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: isNegative
                    ? Colors.red.withOpacity(0.12)
                    : Colors.green.withOpacity(0.12),
                borderRadius: BorderRadius.circular(14),
              ),
              child: _SummaryRow(
                title: "Available Balance",
                amount: availableMoney,
                icon: Icons.savings_outlined,
                isBold: true,
                color: isNegative ? Colors.red : Colors.green,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.title,
    required this.amount,
    required this.icon,
    this.isBold = false,
    this.color,
  });

  final String title;
  final double amount;
  final IconData icon;
  final bool isBold;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final rowColor = color ?? Colors.grey.shade700;

    return Row(
      children: [
        Icon(icon, size: 22, color: rowColor),

        const SizedBox(width: 10),

        Expanded(
          child: Text(
            title,
            style: TextStyle(
              fontSize: isBold ? 16 : 14,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
            ),
          ),
        ),

        Text(
          "₦${amount.toStringAsFixed(2)}",
          style: TextStyle(
            fontSize: isBold ? 16 : 14,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.title,
    required this.value,
    required this.icon,
  });

  final String title;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 22, color: Colors.grey.shade700),

        const SizedBox(width: 10),

        Expanded(
          child: Text(
            title,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ),

        Text(
          value,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
