import 'package:flutter_riverpod/flutter_riverpod.dart';

class SalaryEntry {
  SalaryEntry({
    required this.id,
    required this.amount,
    required this.date,
    required this.description,
  });
  final String id;
  final double amount;
  final String description;
  final DateTime date;

  SalaryEntry copyWith({
    String? id,
    double? amount,
    DateTime? date,
    String? description,
  }) {
    return SalaryEntry(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      description: description ?? this.description,
    );
  }
}

class NewSalaryNotifier extends Notifier<List<SalaryEntry>> {
  @override
  List<SalaryEntry> build() {
    return [];
  }

  void addSalary({
    required String id,
    required double amount,
    required DateTime date,
    required String description,
  }) {
    final newSalary = SalaryEntry(
      id: id,
      amount: amount,
      date: date,
      description: description,
    );
    state = [...state, newSalary];
  }

  void deleteSalary({required String id}) {
    state = state.where((salary) => salary.id != id).toList();
  }

  void editSalary({
    required String id,
    double? amount,
    String? description,
    DateTime? date,
  }) {
    state = state.map((salary) {
      if (salary.id == id) {
        return salary.copyWith(
          amount: amount,
          description: description,
          date: date,
        );
      }
      return salary;
    }).toList();
  }

  double get totalSalary {
    double total = 0;
    for (final salary in state) {
      total += salary.amount;
    }
    return total;
  }
}

final salaryProvider = NotifierProvider<NewSalaryNotifier, List<SalaryEntry>>(
  NewSalaryNotifier.new,
);
