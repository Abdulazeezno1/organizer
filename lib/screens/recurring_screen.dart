import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salaryplan/class/recurring_expense.dart';
import 'package:salaryplan/widget/recurring_wishlist_listview.dart';

class RecurringScreen extends ConsumerWidget {
  const RecurringScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recurringItems = ref.watch(recurringItemProvider);

    if (recurringItems.isEmpty) {
      return const Center(
        child: Text(
          "No recurring item added yet",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      );
    }

    return ListView(
      padding: EdgeInsets.only(left: 12, right: 12, top: 12, bottom: 110),
      children: [RecurringWishlistListview()],
    );
  }
}
