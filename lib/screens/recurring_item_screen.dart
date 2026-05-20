import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salaryplan/class/recurring_expense.dart';
import 'package:salaryplan/core/theme/app_theme.dart';
import 'package:salaryplan/screens/edit_wishlist.dart';

class RecurringItemScreen extends ConsumerStatefulWidget {
  const RecurringItemScreen({super.key, required this.item});

  final RecurringExpense item;

  @override
  ConsumerState<RecurringItemScreen> createState() =>
      _RecurringItemScreenState();
}

class _RecurringItemScreenState extends ConsumerState<RecurringItemScreen> {
  @override
  Widget build(BuildContext context) {
    final items = ref.watch(recurringItemProvider);

    final currentItem = items.firstWhere(
      (item) => item.id == widget.item.id,
      orElse: () => widget.item,
    );

    // final int priority = currentItem.priority.clamp(0, 5).toInt();

    return Scaffold(
      appBar: AppBar(
        title: const Text("WishList Item", style: AppTextStyles.headlineMedium),
        // actions: [
        //   IconButton(
        //     onPressed: () {
        //       showModalBottomSheet(
        //         context: context,
        //         isScrollControlled: true,
        //         builder: (sheetContext) {
        //           return EditWishlist(item: currentItem);
        //         },
        //       );
        //     },
        //     icon: const Icon(Icons.edit),
        //   ),
        // ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 12,
          children: [
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Center(
                      child: Text(
                        currentItem.name,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    Text(
                      '₦ ${currentItem.amount.toStringAsFixed(2)}',
                      style: AppTextStyles.priceStyle,
                    ),

                    const SizedBox(height: 12),

                    // Center(
                    //   child: Column(
                    //     children: [
                    //       Row(
                    //         mainAxisAlignment: MainAxisAlignment.center,
                    //         children: List.generate(5, (index) {
                    //           return Icon(
                    //             index < priority
                    //                 ? Icons.star
                    //                 : Icons.star_border,
                    //             color: Colors.amber,
                    //             size: 26,
                    //           );
                    //         }),
                    //       ),

                    //       const SizedBox(height: 4),

                    //       Text(
                    //         'Priority: $priority/5',
                    //         style: TextStyle(
                    //           color: Colors.grey.shade700,
                    //           fontSize: 14,
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),

            const Divider(height: 2),

            const Text(
              "Description",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            Text(
              currentItem.description == null ||
                      currentItem.description!.isEmpty
                  ? "No description"
                  : currentItem.description!,
            ),

            Text.rich(
              TextSpan(
                children: [
                  const TextSpan(
                    text: "Date Added: ",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text:
                        '${currentItem.dateAdded.day}/${currentItem.dateAdded.month}/${currentItem.dateAdded.year}',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
