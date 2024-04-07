import 'package:cashbook/features/main_app/data/datasource/expense_local_datasource.dart';
import 'package:cashbook/features/main_app/data/models/expense.dart';
import 'package:cashbook/features/main_app/domain/repositories/expense_repository.dart';

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
      required List<TagData> tags}) async {
    return await datasource.addExpense(
        title: title,
        amount: amount,
        description: description,
        date: date,
        tags: tags);
  }

  @override
  Future<void> deleteExpense({required int id}) {
    // TODO: implement deleteExpense
    throw UnimplementedError();
  }

  @override
  Future<List<Expense>> getExpensesFilter(
      {required DateTime startDate,
      required DateTime endDate,
      bool descending = false}) async {
    return await datasource.getExpensesFilter(
        startDate: startDate, endDate: endDate);
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
      List<TagData>? tags}) {
    return datasource.updateExpense(
        id: id,
        title: title,
        amount: amount,
        description: description,
        date: date,
        tags: tags);
  }
}
