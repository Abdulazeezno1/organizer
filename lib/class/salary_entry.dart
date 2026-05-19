import 'package:flutter_riverpod/flutter_riverpod.dart';

class SalaryEntry {
  SalaryEntry({required this.id, required this.amount, required this.date});
  final int id;
  final double amount;
  final DateTime date;

  SalaryEntry copyWith({int? id, double? amount, DateTime? date}) {
    return SalaryEntry(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      date: date ?? this.date,
    );
  }
}

class NewSalaryNotifer extends Notifier<List<SalaryEntry>> {
  @override
  List<SalaryEntry> build() {
    return [];
  }
}
