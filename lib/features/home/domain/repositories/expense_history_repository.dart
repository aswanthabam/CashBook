import 'package:cashbook/data/models/expense.dart';

abstract interface class ExpenseHistoryRepository {
  List<Expense> getExpenseHistory({required int count,
    DateTime? startDate,
    DateTime? endDate,
    bool descending = false});
}
