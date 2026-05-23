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

    final totalWishlist = wishlistItems.fold<double>(
      0,
      (sum, item) => sum + item.price,
    );

    final totalRecurring = recurringItems.fold<double>(
      0,
      (sum, item) => sum + item.amount,
    );

    final totalAmount = totalWishlist + totalRecurring;

    return Scaffold(
      body: isEmpty
          ? const Center(
              child: Text(
                "Add an Item",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            )
          : ListView(
              padding: const EdgeInsets.only(
                left: 12,
                right: 12,
                top: 12,
                bottom: 110,
              ),
              children: const [
                WishlistListview(),
                SizedBox(height: 16),
                RecurringWishlistListview(),
              ],
            ),

      bottomSheet: isEmpty
          ? null
          : SafeArea(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                color: Theme.of(context).scaffoldBackgroundColor,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    "Total Planned Spending: ₦${totalAmount.toStringAsFixed(2)}",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
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
