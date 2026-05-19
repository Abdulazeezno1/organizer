import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:organizer/class/item.dart';
import 'package:organizer/class/recurring_expense.dart';
import 'package:organizer/core/theme/app_theme.dart';
import 'package:organizer/screens/add_recurring_wishlist.dart';
import 'package:organizer/screens/add_wishlist.dart';
import 'package:organizer/screens/item_screen.dart';

class WishlistScreen extends ConsumerStatefulWidget {
  const WishlistScreen({super.key});

  @override
  ConsumerState<WishlistScreen> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends ConsumerState<WishlistScreen> {
  @override
  Widget build(BuildContext context) {
    final item = ref.read(itemProvider.notifier);
    final recurringItem = ref.read(recurringItemProvider.notifier);
    final itemNotifier = ref.watch(itemProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Organize"), // theme handles the style
        centerTitle: true,
      ),

      body: itemNotifier.isEmpty
          ? const Center(
              child: Text(
                "Add an Item",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            )
          : ListView.builder(
              itemCount: itemNotifier.length,
              itemBuilder: (context, index) {
                final itemList = itemNotifier[index];

                return Dismissible(
                  key: ValueKey(itemList.id),
                  onDismissed: (direction) {
                    item.deleteItem(itemList.id);
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
                    trailing: Text("₦${itemList.price}"),
                  ),
                );
              },
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
