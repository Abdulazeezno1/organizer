import 'package:flutter/material.dart';
import 'package:organizer/class/item.dart';

class ItemScreen extends StatefulWidget {
  const ItemScreen({super.key, required this.item});

  final Item item;

  @override
  State<ItemScreen> createState() => _ItemScreenState();
}

class _ItemScreenState extends State<ItemScreen> {
  late final TextEditingController descriptionController;

  @override
  void initState() {
    super.initState();
    descriptionController = TextEditingController(
      text: widget.item.description ?? "",
    );
  }

  @override
  void dispose() {
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final int priority = widget.item.priority.clamp(0, 5);

    return Scaffold(
      appBar: AppBar(title: const Text("WishList Item")),
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
                        widget.item.name,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    Text(
                      '₦ ${widget.item.price.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),

                    const SizedBox(height: 12),

                    Center(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(5, (index) {
                              return Icon(
                                index < priority
                                    ? Icons.star
                                    : Icons.star_border,
                                color: Colors.amber,
                                size: 26,
                              );
                            }),
                          ),

                          const SizedBox(height: 4),

                          Text(
                            'Priority: $priority/5',
                            style: TextStyle(
                              color: Colors.grey.shade700,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Divider(height: 2),
            Text("Description", style: TextStyle(fontWeight: FontWeight.bold)),
            Text(widget.item.description ?? "No description"),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: "Date Added: ",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text:
                        ' ${widget.item.dateAdded.day}/${widget.item.dateAdded.month}/${widget.item.dateAdded.year}',
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
