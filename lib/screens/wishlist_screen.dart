import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:organizer/class/item.dart';
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
    final itemNotifier = ref.watch(itemProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Organize",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
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

      floatingActionButton: AddWishlist(),
    );
  }
}
