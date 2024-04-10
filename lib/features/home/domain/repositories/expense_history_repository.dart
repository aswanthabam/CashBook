import 'package:cashbook/features/home/data/models/expense.dart';

abstract interface class ExpenseHistoryRepository {
  List<Expense> getExpenseHistory(
      {required int count, bool descending = false});
}
