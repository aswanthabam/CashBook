import 'package:cashbook/features/main_app/data/models/expense.dart';
import 'package:cashbook/features/main_app/data/models/tag_data.dart';

abstract interface class ExpenseRepository {
  Future<int> addExpense({
    required String title,
    required double amount,
    required String description,
    required DateTime date,
    required List<TagData> tags,
  });

  Future<void> deleteExpense({required int id});

  Future<int> updateExpense({
    required int id,
    String? title,
    double? amount,
    String? description,
    DateTime? date,
    List<TagData>? tags,
  });

  Future<List<Expense>> getExpensesFilter(
      {required DateTime startDate,
      required DateTime endDate,
      bool descending = false});

  double totalExpense();

  double totalExpenseFilter(
      {required DateTime startDate, required DateTime endDate});
}
