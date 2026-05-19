import 'package:flutter_riverpod/flutter_riverpod.dart';

class RecurringExpense {
  RecurringExpense({
    required this.id,
    required this.name,
    required this.amount,
    required this.frequency,
  });
  final int id;
  final String name;
  final double amount;
  final int frequency;

  RecurringExpense copyWith({
    int? id,
    String? name,
    double? amount,
    int? frequency,
  }) {
    return RecurringExpense(
      id: id ?? this.id,
      name: name ?? this.name,
      amount: amount ?? this.amount,
      frequency: frequency ?? this.frequency,
    );
  }
}

class NewRecurringExpenseNotifier extends Notifier<List<RecurringExpense>> {
  @override
  List<RecurringExpense> build() {
    return [];
  }

  Future<void> addItems(
    int id,
    String name,
    double amount,
    int frequency,
  ) async {
    final newRecurringItems = RecurringExpense(
      id: id,
      name: name,
      amount: amount,
      frequency: frequency,
    );
    state = [...state, newRecurringItems];
  }

  Future<void> removeItems(int id) async {
    state = state.where((item) => item.id != id).toList();
  }
}

final recurringItemProvider =
    NotifierProvider<NewRecurringExpenseNotifier, List<RecurringExpense>>(
      NewRecurringExpenseNotifier.new,
    );
