import 'package:cashbook/data/datasource/expense_local_datasource.dart';
import 'package:cashbook/data/models/expense.dart';
import 'package:cashbook/features/home/domain/repositories/expense_repository.dart';

import '../models/tag_data.dart';

class ExpenseRepositoryImplementation implements ExpenseRepository {
  final ExpenseLocalDatasource datasource;

  ExpenseRepositoryImplementation({required this.datasource});

  @override
  Future<int> addExpense(
      {required String title,
      required double amount,
      required String description,
      required DateTime date,
      required TagData? tag}) async {
    return await datasource.addExpense(
        title: title,
        amount: amount,
        description: description,
        date: date,
        tag: tag);
  }

  @override
  Future<void> deleteExpense({required int id}) {
    // TODO: implement deleteExpense
    throw UnimplementedError();
  }

  @override
  Future<List<Expense>> getExpensesFilter(
      {required int count, bool descending = false}) async {
    return await datasource.getExpensesFilter(
        count: count, descending: descending);
  }

  @override
  double totalExpense() {
    return datasource.totalExpense();
  }

  @override
  double totalExpenseFilter(
      {required DateTime startDate, required DateTime endDate}) {
    return datasource.totalExpenseFilter(
        startDate: startDate, endDate: endDate);
  }

  @override
  Future<int> updateExpense(
      {required int id,
      String? title,
      double? amount,
      String? description,
      DateTime? date,
      TagData? tag}) {
    return datasource.updateExpense(
        id: id,
        title: title,
        amount: amount,
        description: description,
        date: date,
        tag: tag);
  }

  @override
  List<Expense> getDailyExpenses(
      {required DateTime startDate,
      required DateTime endDate,
      bool descending = false}) {
    startDate = endDate
        .subtract(const Duration(days: 30))
        .copyWith(hour: 0, minute: 0, second: 0, millisecond: 0);
    endDate =
        endDate.copyWith(hour: 23, minute: 59, second: 59, millisecond: 999);
    List<Expense> dailyExpenses = [];
    bool start = false;
    for (;
        startDate.isBefore(endDate);
        startDate = startDate.add(const Duration(days: 1))) {
      double total = datasource.totalExpenseFilter(
          startDate: startDate,
          endDate: startDate.add(const Duration(days: 1)));
      if (total == 0 && !start) {
        continue;
      }
      start = true;
      dailyExpenses.add(Expense(
          title: "${startDate.day}/${startDate.month}/${startDate.year}",
          amount: total,
          date: startDate,
          description: "Total expenses for the day",
          id: 0));
    }
    return dailyExpenses;
  }
}
