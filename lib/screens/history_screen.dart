import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salaryplan/class/history_entry.dart';
import 'package:salaryplan/class/salary_entry.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyItems = ref.watch(historyProvider);
    final historyNotifier = ref.read(historyProvider.notifier);
    final salaries = ref.watch(salaryProvider);

    if (historyItems.isEmpty) {
      return const Center(
        child: Text(
          "No item bought yet",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      );
    }

    if (salaries.isEmpty) {
      return ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: historyItems.length,
        itemBuilder: (context, index) {
          final item = historyItems[index];

          return _HistoryTile(
            item: item,
            onDelete: () {
              historyNotifier.deleteHistory(item.id);
            },
          );
        },
      );
    }

    final sortedSalaries = [...salaries]
      ..sort((a, b) => b.date.compareTo(a.date));

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: sortedSalaries.length,
      itemBuilder: (context, salaryIndex) {
        final salary = sortedSalaries[salaryIndex];

        final DateTime cycleStart = salary.date;

        final DateTime? cycleEnd = salaryIndex == 0
            ? null
            : sortedSalaries[salaryIndex - 1].date;

        final cycleItems = historyItems.where((historyItem) {
          final boughtDate = historyItem.dateBought;

          final isAfterCycleStart =
              boughtDate.isAfter(cycleStart) ||
              boughtDate.isAtSameMomentAs(cycleStart);

          final isBeforeCycleEnd =
              cycleEnd == null || boughtDate.isBefore(cycleEnd);

          return isAfterCycleStart && isBeforeCycleEnd;
        }).toList();

        if (cycleItems.isEmpty) {
          return const SizedBox.shrink();
        }

        final totalSpent = cycleItems.fold<double>(
          0,
          (sum, item) => sum + item.price,
        );

        final isCurrentCycle = salaryIndex == 0;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _HistorySectionHeader(
              title: isCurrentCycle
                  ? "Current Salary Cycle"
                  : "Previous Salary Cycle",
              subtitle:
                  "Started ${salary.date.day}/${salary.date.month}/${salary.date.year}",
              totalSpent: totalSpent,
            ),

            const SizedBox(height: 8),

            ...cycleItems.map((item) {
              return _HistoryTile(
                item: item,
                onDelete: () {
                  historyNotifier.deleteHistory(item.id);
                },
              );
            }),

            const SizedBox(height: 16),
          ],
        );
      },
    );
  }
}

class _HistorySectionHeader extends StatelessWidget {
  const _HistorySectionHeader({
    required this.title,
    required this.subtitle,
    required this.totalSpent,
  });

  final String title;
  final String subtitle;
  final double totalSpent;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.green.withOpacity(0.12),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            const Icon(Icons.history, color: Colors.green),

            const SizedBox(width: 10),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
                  ),
                ],
              ),
            ),

            Text(
              "₦${totalSpent.toStringAsFixed(2)}",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

class _HistoryTile extends StatelessWidget {
  const _HistoryTile({required this.item, required this.onDelete});

  final HistoryEntry item;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(item.id),
      onDismissed: (direction) {
        onDelete();
      },
      child: Card(
        child: ListTile(
          leading: const Icon(Icons.shopping_bag_outlined),
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
  }
}
