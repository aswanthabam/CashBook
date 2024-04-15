import 'package:cashbook/core/types/reponse_types.dart';
import 'package:cashbook/core/usecase/usecase.dart';
import 'package:cashbook/data/models/expense.dart';
import 'package:cashbook/domain/repositories/expense_history_repository.dart';
import 'package:fpdart/fpdart.dart';

class ExpenseHistoryUseCase
    implements UseCase<List<Expense>, Failure, ExpenseHistoryParams> {
  final ExpenseHistoryRepository repository;

  ExpenseHistoryUseCase({required this.repository});

  @override
  Future<Either<List<Expense>, Failure>> call(
      ExpenseHistoryParams params) async {
    try {
      List<Expense> expenses = repository.getExpenseHistory(
          count: params.count,
          startDate: params.startDate,
          endDate: params.endDate,
          descending: params.descending);
      return left(expenses);
    } catch (e) {
      return right(Failure(e.toString()));
    }
  }
}

class ExpenseHistoryParams {
  final int count;
  final DateTime? startDate;
  final DateTime? endDate;
  final bool descending;

  ExpenseHistoryParams(
      {required this.count,
      this.startDate,
      this.endDate,
      required this.descending});
}
