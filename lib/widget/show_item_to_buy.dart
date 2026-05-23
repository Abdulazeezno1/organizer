import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salaryplan/class/history_entry.dart';
import 'package:salaryplan/class/item.dart';
import 'package:salaryplan/class/recurring_expense.dart';
import 'package:salaryplan/class/salary_entry.dart';
import 'package:salaryplan/screens/item_screen.dart';
import 'package:salaryplan/widget/confirm_alert.dart';

class ShowItemToBuy extends ConsumerWidget {
  const ShowItemToBuy({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final salaries = ref.watch(salaryProvider);
    final historyItems = ref.watch(historyProvider);
    final wishlistItems = ref.watch(itemProvider);
    final recurringItems = ref.watch(recurringItemProvider);

    if (salaries.isEmpty) {
      return const Center(child: Text("Add your salary first"));
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

    final availableMoney =
        latestSalary.amount - recurringExpenses - totalBought;

    final sortedItems = [...wishlistItems]
      ..sort((a, b) {
        final priorityCompare = b.priority.compareTo(a.priority);

        if (priorityCompare != 0) {
          return priorityCompare;
        }

        return a.price.compareTo(b.price);
      });

    final List<Item> recommendedItems = [];
    double remainingMoney = availableMoney;

    for (final item in sortedItems) {
      if (item.price <= remainingMoney) {
        recommendedItems.add(item);
        remainingMoney -= item.price;
      }
    }

    if (recommendedItems.isEmpty) {
      return const Center(
        child: Text("No wishlist item fits your current budget"),
      );
    }

    String getPriorityLabel(int priority) {
      if (priority >= 4) return "High Priority";
      if (priority >= 2) return "Medium Priority";
      return "Low Priority";
    }

    Color getPriorityColor(int priority) {
      if (priority >= 4) return Colors.red;
      if (priority >= 2) return Colors.orange;
      return Colors.green;
    }

    String getPayCycleText() {
      if (latestSalary.payCycle == Frequencies.weekly) {
        return "Weekly";
      }

      return "Monthly";
    }

    return SizedBox.expand(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Recommended items to buy",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),

          const SizedBox(height: 4),

          Text(
            "Based on your ${getPayCycleText().toLowerCase()} salary cycle",
            style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
          ),

          const SizedBox(height: 8),

          Expanded(
            child: ListView.builder(
              itemCount: recommendedItems.length,
              itemBuilder: (context, index) {
                final item = recommendedItems[index];

                return Card(
                  child: ListTile(
                    leading: IconButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return ConfirmAlert(item: item);
                          },
                        );
                      },
                      icon: const Icon(Icons.check_circle, color: Colors.green),
                    ),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ItemScreen(item: item),
                        ),
                      );
                    },
                    title: Text(item.name),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Chip(
                          label: Text(getPriorityLabel(item.priority)),
                          backgroundColor: getPriorityColor(
                            item.priority,
                          ).withOpacity(0.12),
                          labelStyle: TextStyle(
                            color: getPriorityColor(item.priority),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    trailing: Text(
                      "₦${item.price.toStringAsFixed(2)}",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 12),

          Text(
            "Remaining after recommended items: ₦${remainingMoney.toStringAsFixed(2)}",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
