import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salaryplan/class/item.dart';
import 'package:salaryplan/screens/item_screen.dart';

class WishlistListview extends ConsumerWidget {
  const WishlistListview({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemNotifier = ref.read(itemProvider.notifier);
    final wishlistItems = ref.watch(itemProvider);

    if (wishlistItems.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Wishlist Items",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),

        const SizedBox(height: 8),

        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: wishlistItems.length,
          itemBuilder: (context, index) {
            final itemList = wishlistItems[index];

            return Dismissible(
              key: ValueKey("wishlist-${itemList.id}"),
              onDismissed: (direction) {
                itemNotifier.deleteItem(itemList.id);
              },
              child: Card(
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
              ),
            );
          },
        ),
      ],
    );
  }
}
