import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salaryplan/class/history_entry.dart';
import 'package:salaryplan/class/item.dart';
import 'package:salaryplan/class/recurring_expense.dart';
import 'package:salaryplan/class/salary_entry.dart';

class ConfirmAlert extends ConsumerWidget {
  const ConfirmAlert({super.key, required this.item});

  final Item item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyNotifier = ref.read(historyProvider.notifier);
    final itemNotifier = ref.read(itemProvider.notifier);

    final historyItems = ref.watch(historyProvider);
    final salaries = ref.watch(salaryProvider);
    final recurringItems = ref.watch(recurringItemProvider);

    if (salaries.isEmpty) {
      return AlertDialog(
        title: const Text("No salary found"),
        content: const Text("Add your salary before buying an item."),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("OK"),
          ),
        ],
      );
    }

    final latestSalary = salaries.last;

    final payCycleForExpenses = latestSalary.payCycle == Frequencies.weekly
        ? Frequency.weekly
        : Frequency.monthly;

    final boughtAfterSalary = historyItems.where((historyItem) {
      return historyItem.dateBought.isAfter(latestSalary.date);
    }).toList();

    final totalBought = boughtAfterSalary.fold<double>(
      0,
      (sum, item) => sum + item.price,
    );

    final recurringExpenses = calculateTotalExpenses(
      recurringItems,
      payCycleForExpenses,
    );

    final availableMoney =
        latestSalary.amount - recurringExpenses - totalBought;

    final availableMoneyAfterBuying = availableMoney - item.price;

    void bought(Item currentItem) {
      historyNotifier.addToHistory(
        itemId: currentItem.id,
        name: currentItem.name,
        price: currentItem.price,
        description: currentItem.description,
        priority: currentItem.priority,
        dateAdded: currentItem.dateAdded,
      );

      itemNotifier.deleteItem(currentItem.id);
    }

    return AlertDialog(
      title: const Text("Mark this item as bought?"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.name,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),

          const SizedBox(height: 12),

          Text("Item price: ₦${item.price.toStringAsFixed(2)}"),

          const SizedBox(height: 6),

          Text("Current balance: ₦${availableMoney.toStringAsFixed(2)}"),

          const SizedBox(height: 6),

          Text(
            "Balance after buying: ₦${availableMoneyAfterBuying.toStringAsFixed(2)}",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: availableMoneyAfterBuying < 0 ? Colors.red : Colors.green,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("Cancel"),
        ),
        FilledButton(
          onPressed: () {
            bought(item);
            Navigator.pop(context);
          },
          child: const Text("Yes, bought"),
        ),
      ],
    );
  }
}
