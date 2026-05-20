import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salaryplan/class/recurring_expense.dart';
import 'package:salaryplan/screens/recurring_item_screen.dart';

class RecurringWishlistListview extends ConsumerWidget {
  const RecurringWishlistListview({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recurringItemNotifier = ref.read(recurringItemProvider.notifier);
    final recurringItems = ref.watch(recurringItemProvider);

    if (recurringItems.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Recurring Items",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),

        const SizedBox(height: 8),

        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: recurringItems.length,
          itemBuilder: (context, index) {
            final itemList = recurringItems[index];

            return Dismissible(
              key: ValueKey("recurring-${itemList.id}"),
              onDismissed: (direction) {
                recurringItemNotifier.removeItems(itemList.id);
              },
              child: ListTile(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (ctx) => RecurringItemScreen(item: itemList),
                    ),
                  );
                },
                title: Text(itemList.name),
                trailing: Text("₦${itemList.amount}"),
              ),
            );
          },
        ),
      ],
    );
  }
}
