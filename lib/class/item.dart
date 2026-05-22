import 'package:flutter_riverpod/flutter_riverpod.dart';

class Item {
  const Item({
    required this.id,
    required this.name,
    required this.price,
    this.description,
    required this.isPurchased,
    required this.priority,
    required this.dateAdded,
  });
  final String id;
  final String name;
  final double price;
  final String? description;
  final int priority;
  final bool isPurchased;
  final DateTime dateAdded;

  Item copyWith({
    String? id,
    String? name,
    double? price,
    String? description,
    int? priority,
    bool? isPurchased,
    DateTime? dateAdded,
  }) {
    return Item(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      description: description ?? this.description,
      isPurchased: isPurchased ?? this.isPurchased,
      priority: priority ?? this.priority,
      dateAdded: dateAdded ?? this.dateAdded,
    );
  }
}

class NewItemNotifier extends Notifier<List<Item>> {
  @override
  List<Item> build() {
    return [];
  }

  Future<void> addItem({
    required String id,
    required String name,
    required double price,
    String? description,
    required int priority,
    required bool isPurchased,
    required DateTime dateAdded,
  }) async {
    final newItem = Item(
      id: id,
      name: name,
      price: price,
      description: description,
      priority: priority,
      isPurchased: isPurchased,
      dateAdded: dateAdded,
    );

    state = [...state, newItem];
  }

  Future<void> deleteItem(String itemId) async {
    state = state.where((item) => item.id != itemId).toList();
  }

  Future<void> editItem({
    required String id,
    required String name,
    required double price,
    String? description,
    required int priority,
    required bool isPurchased,
  }) async {
    state = state.map((item) {
      if (item.id == id) {
        return item.copyWith(
          name: name,
          price: price,
          description: description,
          priority: priority,
          isPurchased: isPurchased,
        );
      }

      return item;
    }).toList();
  }
}

final itemProvider = NotifierProvider<NewItemNotifier, List<Item>>(
  NewItemNotifier.new,
);
