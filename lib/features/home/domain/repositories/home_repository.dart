import 'package:cashbook/data/models/expense.dart';

abstract interface class HomeRepository {
  Future<List<Expense>> getExpenseList(
      {required DateTime startDate, required DateTime endDate});

  double totalExpense();

  double totalExpenseFilter(
      {required DateTime startDate, required DateTime endDate});
}
