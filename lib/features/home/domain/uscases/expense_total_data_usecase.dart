import 'package:cashbook/core/exceptions/datasource_expensions.dart';
import 'package:cashbook/core/types/reponse_types.dart';
import 'package:cashbook/core/usecase/usecase.dart';
import 'package:cashbook/data/models/expense.dart';
import 'package:cashbook/domain/repositories/expense_repository.dart';
import 'package:fpdart/src/either.dart';

class ExpenseTotalDataUseCase
    implements UseCase<ExpenseTotalData, Failure, ExpenseTotalDataParams> {
  final ExpenseRepository repository;

  const ExpenseTotalDataUseCase({required this.repository});

  @override
  Future<Either<ExpenseTotalData, Failure>> call(
      ExpenseTotalDataParams param) async {
    try {
      List<Expense> expenses = repository.getDailyExpenses(
          startDate: param.startDate, endDate: param.endDate);
      double total = expenses.fold(
          0, (previousValue, element) => previousValue + element.amount);
      return left(ExpenseTotalData(dailyExpenses: expenses, total: total));
    } on LocalDatabaseException catch (e) {
      return right(Failure(e.message));
    }
  }
}

class ExpenseTotalData {
  final List<Expense> dailyExpenses;
  final double total;

  const ExpenseTotalData({required this.dailyExpenses, required this.total});
}

class ExpenseTotalDataParams {
  final DateTime startDate;
  final DateTime endDate;

  const ExpenseTotalDataParams(
      {required this.startDate, required this.endDate});
}
