import 'package:cashbook/features/main_app/data/models/expense.dart';

abstract interface class ExpenseRepository {
  Future<int> addExpense({
    required String title,
    required double amount,
    required String description,
    required DateTime date,
    required List<int> tags,
  });

  Future<void> deleteExpense({required int id});

  Future<void> updateExpense({
    required int id,
    String? title,
    double? amount,
    String? description,
    DateTime? date,
    List<int>? tags,
  });

  Future<List<Expense>> getExpensesFilter(
      {required DateTime startDate,
      required DateTime endDate,
      bool descending = false});

  double totalExpense();

  double totalExpenseFilter(
      {required DateTime startDate, required DateTime endDate});
}
