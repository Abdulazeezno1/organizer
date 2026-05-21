import 'package:flutter_riverpod/flutter_riverpod.dart';

enum Frequency { weekly, monthly }

class RecurringExpense {
  RecurringExpense({
    required this.id,
    required this.name,
    required this.amount,
    required this.frequency,
    required this.description,
    required this.dateAdded,
  });
  final String id;
  final String name;
  final double amount;
  final Frequency frequency;
  final String description;
  final DateTime dateAdded;

  RecurringExpense copyWith({
    String? id,
    String? name,
    double? amount,
    Frequency? frequency,
    String? description,
    DateTime? dateAdded,
  }) {
    return RecurringExpense(
      id: id ?? this.id,
      name: name ?? this.name,
      amount: amount ?? this.amount,
      frequency: frequency ?? this.frequency,
      description: description ?? this.description,
      dateAdded: dateAdded ?? this.dateAdded,
    );
  }
}

class NewRecurringExpenseNotifier extends Notifier<List<RecurringExpense>> {
  @override
  List<RecurringExpense> build() {
    return [];
  }

  Future<void> addItems(
    String id,
    String name,
    double amount,
    Frequency frequency,
    String description,
    DateTime dateAdded,
  ) async {
    final newRecurringItems = RecurringExpense(
      id: id,
      name: name,
      amount: amount,
      frequency: frequency,
      description: description,
      dateAdded: dateAdded,
    );
    state = [...state, newRecurringItems];
  }

  Future<void> removeItems(String id) async {
    state = state.where((item) => item.id != id).toList();
  }
}

double calculateTotalExpenses(
  List<RecurringExpense> expenses,
  Frequency payCycle,
) {
  const double weeksPerMonth = 52 / 12;

  double total = 0;

  for (final expense in expenses) {
    if (expense.frequency == Frequency.monthly) {
      total += payCycle == Frequency.weekly
          ? expense.amount / weeksPerMonth
          : expense.amount;
    } else {
      total += payCycle == Frequency.weekly
          ? expense.amount
          : expense.amount * weeksPerMonth;
    }
  }

  return total;
}

final recurringItemProvider =
    NotifierProvider<NewRecurringExpenseNotifier, List<RecurringExpense>>(
      NewRecurringExpenseNotifier.new,
    );
