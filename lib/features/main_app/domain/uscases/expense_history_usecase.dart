import 'package:cashbook/core/types/reponse_types.dart';
import 'package:cashbook/core/usecase/usecase.dart';
import 'package:cashbook/features/main_app/data/models/expense.dart';
import 'package:cashbook/features/main_app/domain/repositories/expense_repository.dart';
import 'package:fpdart/src/either.dart';

class ExpenseDataUseCase
    implements
        UseCase<Success<ExpenseListResult>, Failure, ExpenseHistoryParams> {
  final ExpenseRepository repository;

  ExpenseDataUseCase(this.repository);

  @override
  Future<Either<Success<ExpenseListResult>, Failure>> call(
      ExpenseHistoryParams params) async {
    try {
      List<Expense> expenses = await repository.getExpensesFilter(
          startDate: params.startDate, endDate: params.endDate);
      double total = repository.totalExpense();
      return left(
          Success("", ExpenseListResult(expenses: expenses, total: total)));
    } catch (e) {
      return right(Failure(e.toString()));
    }
  }
}

class ExpenseListResult {
  final List<Expense> expenses;
  final double total;

  ExpenseListResult({required this.expenses, required this.total});
}

class ExpenseHistoryParams {
  final DateTime startDate;
  final DateTime endDate;

  ExpenseHistoryParams({required this.startDate, required this.endDate});
}
