import 'package:cashbook/core/types/reponse_types.dart';
import 'package:cashbook/core/usecase/usecase.dart';
import 'package:cashbook/features/main_app/data/models/expense.dart';
import 'package:cashbook/features/main_app/domain/repositories/expense_repository.dart';
import 'package:fpdart/src/either.dart';

class ExpenseHistoryUseCase
    implements UseCase<Success<List<Expense>>, Failure, ExpenseHistoryParams> {
  final ExpenseRepository repository;

  ExpenseHistoryUseCase(this.repository);

  @override
  Future<Either<Success<List<Expense>>, Failure>> call(
      ExpenseHistoryParams params) async {
    return await repository.getExpensesFilter(
        startDate: params.startDate, endDate: params.endDate);
  }
}

class ExpenseHistoryParams {
  final DateTime startDate;
  final DateTime endDate;

  ExpenseHistoryParams({required this.startDate, required this.endDate});
}
