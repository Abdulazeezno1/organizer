import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salaryplan/class/item.dart';
import 'package:salaryplan/class/recurring_expense.dart';
import 'package:salaryplan/class/salary_entry.dart';

class ShowItemToBuy extends ConsumerWidget {
  const ShowItemToBuy({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final salaries = ref.watch(salaryProvider);
    final wishlistItems = ref.watch(itemProvider);
    final recurringItems = ref.watch(recurringItemProvider);

    if (salaries.isEmpty) {
      return const Center(child: Text("Add your salary first"));
    }

    final latestSalary = salaries.last;

    final monthlyExpenses = calculateTotalExpenses(
      recurringItems,
      Frequency.monthly,
    );

    final availableMoney = latestSalary.amount - monthlyExpenses;

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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Available after expenses: ₦${availableMoney.toStringAsFixed(2)}",
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),

        const SizedBox(height: 12),

        const Text(
          "Recommended items to buy",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),

        const SizedBox(height: 8),

        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: recommendedItems.length,
          itemBuilder: (context, index) {
            final item = recommendedItems[index];

            return ListTile(
              title: Text(item.name),
              subtitle: Text("Priority: ${item.priority}/5"),
              trailing: Text("₦${item.price.toStringAsFixed(2)}"),
            );
          },
        ),

        const SizedBox(height: 12),

        Text(
          "Remaining after recommended items: ₦${remainingMoney.toStringAsFixed(2)}",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
