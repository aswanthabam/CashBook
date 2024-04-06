import 'package:cashbook/core/types/reponse_types.dart';
import 'package:cashbook/features/main_app/data/datasource/expense_local_datasource.dart';
import 'package:cashbook/features/main_app/data/models/expense.dart';
import 'package:cashbook/features/main_app/domain/repositories/expense_repository.dart';
import 'package:fpdart/fpdart.dart%20%20';

class ExpenseRepositoryImplementation implements ExpenseRepository {
  final ExpenseLocalDatasource datasource;

  ExpenseRepositoryImplementation({required this.datasource});

  @override
  Future<int> addExpense(
      {required String title,
      required double amount,
      required String description,
      required DateTime date,
      required List<int> tags}) async {
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
  Future<Either<Success<List<Expense>>, Failure>> getExpensesFilter(
      {required DateTime startDate,
      required DateTime endDate,
      bool descending = false}) async {
    try {
      return left(Success<List<Expense>>(
          "Successfully Fetched History",
          await datasource.getExpensesFilter(
              startDate: startDate, endDate: endDate)));
    } catch (e) {
      return right(Failure("An error occurred"));
    }
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
  Future<void> updateExpense(
      {required int id,
      String? title,
      double? amount,
      String? description,
      DateTime? date,
      List<int>? tags}) {
    // TODO: implement updateExpense
    throw UnimplementedError();
  }
}
