import 'package:cashbook/features/main_app/domain/models/tag_data.dart';

class Expense {
  final String id;
  final double amount;
  final String? description;
  final List<TagData>? tags;

  const Expense(
      {required this.id,
      required this.amount,
      required this.description,
      this.tags});
}

class ExpenseList {
  final List<Expense> expenses;
  final DateTime startDate;
  final DateTime endDate;
  final double totalAmount;

  const ExpenseList(
      {required this.expenses,
      required this.startDate,
      required this.endDate,
      required this.totalAmount});
}
