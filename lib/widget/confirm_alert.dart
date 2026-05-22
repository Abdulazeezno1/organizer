import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salaryplan/class/history_entry.dart';
import 'package:salaryplan/class/item.dart';

class ConfirmAlert extends ConsumerWidget {
  const ConfirmAlert({super.key, required this.item});

  final Item item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyNotifier = ref.read(historyProvider.notifier);
    final itemNotifier = ref.read(itemProvider.notifier);

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
      content: Text("Are you sure you bought ${item.name}?"),
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
