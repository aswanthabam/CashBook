import 'package:cashbook/core/types/reponse_types.dart';
import 'package:cashbook/features/main_app/data/models/expense.dart';
import 'package:fpdart/fpdart.dart%20%20';

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

  Future<Either<Success<List<Expense>>, Failure>> getExpensesFilter(
      {required DateTime startDate,
      required DateTime endDate,
      bool descending = false});

  double totalExpense();

  double totalExpenseFilter(
      {required DateTime startDate, required DateTime endDate});
}
