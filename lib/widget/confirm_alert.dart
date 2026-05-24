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
    final historyItems = ref.watch(historyProvider);
    final itemNotifier = ref.read(itemProvider.notifier);
    final salaries = ref.watch(salaryProvider);
    final recurringItems = ref.watch(recurringItemProvider);
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

    final salary = salaries.last;
    final payCycleForExpenses = salary.payCycle == Frequencies.weekly
        ? Frequency.weekly
        : Frequency.monthly;
    final latestSalary = salaries.last;

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

    final availableMoney = salary.amount - recurringExpenses - totalBought;
    final availableMoneyAfterBrought = availableMoney - item.price;
    return AlertDialog(
      title: const Text("Mark this item as bought?"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Buy this item?", style: TextStyle(fontWeight: FontWeight.bold)),
          Text(
            "Item price: ${item.price}?",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
            "Balance after buying: $availableMoneyAfterBrought?",
            style: TextStyle(fontWeight: FontWeight.bold),
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
