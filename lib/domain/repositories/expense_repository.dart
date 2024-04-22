import 'package:cashbook/data/models/expense.dart';
import 'package:cashbook/data/models/tag_data.dart';

abstract interface class ExpenseRepository {
  Future<Expense> addExpense({
    required String title,
    required double amount,
    required String description,
    required DateTime date,
    required TagData? tag,
    int isLiability = 0,
  });

  Future<void> deleteExpense({required int id});

  Future<Expense> updateExpense({
    required int id,
    String? title,
    double? amount,
    String? description,
    DateTime? date,
    TagData? tag,
  });

  Future<List<Expense>> getExpensesFilter({required int count,
      bool descending = false});

  double totalExpense();

  double totalExpenseFilter(
      {required DateTime startDate, required DateTime endDate});

  List<Expense> getDailyExpenses(
      {required DateTime startDate,
      required DateTime endDate,
      bool descending = false});
}
