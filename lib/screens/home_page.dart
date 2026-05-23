import 'package:flutter/material.dart';
import 'package:salaryplan/class/history_entry.dart';
import 'package:salaryplan/class/recurring_expense.dart';
import 'package:salaryplan/class/salary_entry.dart';
import 'package:salaryplan/widget/add_salary.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.account_balance_wallet_outlined,
                    size: 48,
                    color: Colors.grey.shade700,
                  ),

                  const SizedBox(height: 12),

                  const Text(
                    "No salary added yet",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    "Add your salary to see buying recommendations.",
                    textAlign: TextAlign.center,
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

    final monthlyExpenses = calculateTotalExpenses(
      recurringItems,
      Frequency.monthly,
    );

    final salary = latestSalary.amount;

    final availableMoney = salary - monthlyExpenses - totalBought;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Current Salary Cycle",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
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

                    const SizedBox(height: 12),

                    _SummaryRow(
                      title: "Salary",
                      amount: salary,
                      icon: Icons.account_balance_wallet_outlined,
                    ),

                    const SizedBox(height: 10),

                    _SummaryRow(
                      title: "Recurring Expenses",
                      amount: monthlyExpenses,
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
                        color: Colors.green.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: _SummaryRow(
                        title: "Available Balance",
                        amount: availableMoney,
                        icon: Icons.savings_outlined,
                        isBold: true,
                      ),
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
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.title,
    required this.amount,
    required this.icon,
    this.isBold = false,
  });

  final String title;
  final double amount;
  final IconData icon;
  final bool isBold;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 22,
          color: isBold ? Colors.green : Colors.grey.shade700,
        ),

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
            color: isBold ? Colors.green.shade700 : null,
          ),
        ),
      ],
    );
  }
}
