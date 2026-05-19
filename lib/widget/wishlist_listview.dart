import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:organizer/class/recurring_expense.dart';
import 'package:organizer/screens/item_screen.dart';

class WishlistListview extends ConsumerWidget {
  const WishlistListview({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final item = ref.read(recurringItemProvider.notifier);
    final recurringItem = ref.watch(recurringItemProvider);
    return Column(
      children: [
        Text("Recurring Items"),
        ListView.builder(
          itemCount: recurringItem.length,
          itemBuilder: (context, index) {
            final itemList = recurringItem[index];

            return Dismissible(
              key: ValueKey(itemList.id),
              onDismissed: (direction) {
                item.removeItems(itemList.id);
              },
              child: ListTile(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (ctx) => ItemScreen(item: itemList),
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
