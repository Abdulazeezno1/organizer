import 'package:flutter_riverpod/flutter_riverpod.dart';

enum Frequencies { weekly, monthly }

class SalaryEntry {
  const SalaryEntry({
    required this.id,
    required this.amount,
    this.description,
    required this.payCycle,
    required this.date,
  });

  final String id;
  final double amount;
  final String? description;
  final Frequencies payCycle;
  final DateTime date;

  SalaryEntry copyWith({
    String? id,
    double? amount,
    String? description,
    Frequencies? payCycle,
    DateTime? date,
  }) {
    return SalaryEntry(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      description: description ?? this.description,
      payCycle: payCycle ?? this.payCycle,
      date: date ?? this.date,
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
    String? description,
    required Frequencies payCycle,
    required DateTime date,
  }) {
    final newSalary = SalaryEntry(
      id: id,
      amount: amount,
      description: description,
      payCycle: payCycle,
      date: date,
    );

    state = [...state, newSalary];
  }

  void editSalary({
    required String id,
    required double amount,
    String? description,
    required Frequencies payCycle,
    required DateTime date,
  }) {
    state = state.map((salary) {
      if (salary.id == id) {
        return salary.copyWith(
          amount: amount,
          description: description,
          payCycle: payCycle,
          date: date,
        );
      }

      return salary;
    }).toList();
  }

  void deleteSalary(String id) {
    state = state.where((salary) => salary.id != id).toList();
  }
}

final salaryProvider = NotifierProvider<NewSalaryNotifier, List<SalaryEntry>>(
  NewSalaryNotifier.new,
);
