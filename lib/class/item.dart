import 'package:flutter_riverpod/flutter_riverpod.dart';

class Item {
  const Item({
    required this.name,
    required this.price,
    required this.description,
  });

  final String name;
  final double price;
  final String description;

  Item copyWith({String? name, double? price, String? description}) {
    return Item(
      name: name ?? this.name,
      price: price ?? this.price,
      description: description ?? this.description,
    );
  }
}

class NewItemNotifier extends Notifier<List<Item>> {
  @override
  List<Item> build() {
    return [];
  }

  Future<void> addItem({
    required String name,
    required double price,
    required String description,
  }) async {
    final newItem = Item(name: name, price: price, description: description);

    state = [...state, newItem];
  }
}

final itemProvider = NotifierProvider<NewItemNotifier, List<Item>>(
  NewItemNotifier.new,
);
