import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salaryplan/class/history_entry.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyItems = ref.watch(historyProvider);
    final historyNotifier = ref.read(historyProvider.notifier);

    if (historyItems.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text("History"), centerTitle: true),
        body: Center(
          child: Text(
            "No item bought yet",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("History"), centerTitle: true),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: historyItems.length,
        itemBuilder: (context, index) {
          final item = historyItems[index];

          return Dismissible(
            key: ValueKey(item.id),
            onDismissed: (direction) {
              historyNotifier.deleteHistory(item.id);
            },
            child: Card(
              child: ListTile(
                title: Text(item.name),
                subtitle: Text(
                  "Bought on: ${item.dateBought.day}/${item.dateBought.month}/${item.dateBought.year}",
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
    );
  }
}
