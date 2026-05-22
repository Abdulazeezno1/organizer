import 'package:flutter_riverpod/flutter_riverpod.dart';

class HistoryEntry {
  const HistoryEntry({
    required this.id,
    required this.itemId,
    required this.name,
    required this.price,
    required this.description,
    required this.priority,
    required this.dateAdded,
    required this.dateBought,
  });
  final String id;
  final String itemId;
  final String name;
  final double price;
  final String? description;

  final int priority;
  final DateTime dateAdded;
  final DateTime dateBought;
}

class HistoryNotifier extends Notifier<List<HistoryEntry>> {
  @override
  List<HistoryEntry> build() {
    return [];
  }

  void addToHistory({
    required String itemId,
    required String name,
    required double price,
    String? description,
    required int priority,
    required DateTime dateAdded,
  }) {
    final historyItem = HistoryEntry(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      itemId: itemId,
      name: name,
      price: price,
      description: description,
      priority: priority,
      dateAdded: dateAdded,
      dateBought: DateTime.now(),
    );
    state = [...state, historyItem];
  }

  void deleteHistory(String id) {
    state = state.where((item) => item.id != id).toList();
  }
}

final historyProvider = NotifierProvider<HistoryNotifier, List<HistoryEntry>>(
  HistoryNotifier.new,
);
