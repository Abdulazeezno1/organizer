import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salaryplan/class/item.dart';
import 'package:salaryplan/class/recurring_expense.dart';
import 'package:salaryplan/screens/add_recurring_wishlist.dart';
import 'package:salaryplan/screens/add_wishlist.dart';
import 'package:salaryplan/widget/recurring_wishlist_listview.dart';
import 'package:salaryplan/widget/wishlist_listview.dart';

class WishlistScreen extends ConsumerStatefulWidget {
  const WishlistScreen({super.key});

  @override
  ConsumerState<WishlistScreen> createState() {
    return _WishlistScreenState();
  }
}

class _WishlistScreenState extends ConsumerState<WishlistScreen> {
  @override
  Widget build(BuildContext context) {
    final wishlistItems = ref.watch(itemProvider);
    final recurringItems = ref.watch(recurringItemProvider);

    final bool isEmpty = wishlistItems.isEmpty && recurringItems.isEmpty;

    return Scaffold(
      appBar: AppBar(title: const Text("Organize"), centerTitle: true),

      body: isEmpty
          ? const Center(
              child: Text(
                "Add an Item",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            )
          : ListView(
              padding: EdgeInsets.all(12),
              children: [
                WishlistListview(),
                SizedBox(height: 16),
                RecurringWishlistListview(),
              ],
            ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (context) {
              return Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "What do you want to add?",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 16),

                    ListTile(
                      leading: const Icon(Icons.shopping_bag_outlined),
                      title: const Text("One-time item"),
                      subtitle: const Text("Add something you only need once"),
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
                      subtitle: const Text(
                        "Add something you buy again and again",
                      ),
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
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
