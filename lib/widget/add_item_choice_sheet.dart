import 'package:flutter/material.dart';
import 'package:salaryplan/screens/add_wishlist.dart';
import 'package:salaryplan/screens/add_recurring_wishlist.dart';

class AddItemChoiceSheet extends StatelessWidget {
  const AddItemChoiceSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "What do you want to add?",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 16),

          ListTile(
            leading: const Icon(Icons.shopping_bag_outlined),
            title: const Text("One-time item"),
            subtitle: const Text("An item you only plan to buy once"),
            onTap: () {
              Navigator.pop(context);

              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (context) {
                  return const AddWishlist();
                },
              );
            },
          ),

          ListTile(
            leading: const Icon(Icons.repeat),
            title: const Text("Recurring item"),
            subtitle: const Text("An item you buy weekly or monthly"),
            onTap: () {
              Navigator.pop(context);

              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (context) {
                  return const AddRecurringWishlist();
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
