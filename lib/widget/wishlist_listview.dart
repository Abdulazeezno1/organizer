import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salaryplan/class/history_entry.dart';
import 'package:salaryplan/class/item.dart';
import 'package:salaryplan/class/recurring_expense.dart';
import 'package:salaryplan/class/salary_entry.dart';
import 'package:salaryplan/screens/item_screen.dart';

class WishlistListview extends ConsumerWidget {
  const WishlistListview({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemNotifier = ref.read(itemProvider.notifier);
    final wishlistItems = ref.watch(itemProvider);

    final salaries = ref.watch(salaryProvider);
    final recurringItems = ref.watch(recurringItemProvider);
    final historyItems = ref.watch(historyProvider);

    if (wishlistItems.isEmpty) {
      return const SizedBox.shrink();
    }

    double availableMoney = 0;

    if (salaries.isNotEmpty) {
      final latestSalary = salaries.last;

      final monthlyExpenses = calculateTotalExpenses(
        recurringItems,
        Frequency.monthly,
      );

      final boughtAfterSalary = historyItems.where((historyItem) {
        return historyItem.dateBought.isAfter(latestSalary.date);
      }).toList();

      final totalBought = boughtAfterSalary.fold<double>(
        0,
        (sum, item) => sum + item.price,
      );

      availableMoney = latestSalary.amount - monthlyExpenses - totalBought;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Wishlist Items",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),

        const SizedBox(height: 8),

        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: wishlistItems.length,
          itemBuilder: (context, index) {
            final item = wishlistItems[index];

            final bool canBuyNow =
                salaries.isNotEmpty && item.price <= availableMoney;

            return Dismissible(
              key: ValueKey("wishlist-${item.id}"),
              onDismissed: (direction) {
                itemNotifier.deleteItem(item.id);
              },
              child: Card(
                child: ListTile(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (ctx) => ItemScreen(item: item),
                      ),
                    );
                  },
                  title: Text(item.name),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Chip(
                        label: Text(
                          salaries.isEmpty
                              ? "Add salary first"
                              : canBuyNow
                              ? "Can buy now"
                              : "Not enough balance",
                        ),
                        backgroundColor: salaries.isEmpty
                            ? Colors.grey.withOpacity(0.15)
                            : canBuyNow
                            ? Colors.green.withOpacity(0.15)
                            : Colors.red.withOpacity(0.15),
                        labelStyle: TextStyle(
                          color: salaries.isEmpty
                              ? Colors.grey
                              : canBuyNow
                              ? Colors.green
                              : Colors.red,
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
              ),
            );
          },
        ),
      ],
    );
  }
}
