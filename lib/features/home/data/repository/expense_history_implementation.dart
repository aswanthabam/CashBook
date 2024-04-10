import 'package:cashbook/features/home/data/datasource/expense_local_datasource.dart';
import 'package:cashbook/features/home/data/models/expense.dart';
import 'package:cashbook/features/home/domain/repositories/expense_history_repository.dart';

class ExpenseHistoryRepositoryImplementation
    implements ExpenseHistoryRepository {
  final ExpenseLocalDatasource expenseLocalDatasource;

  const ExpenseHistoryRepositoryImplementation(this.expenseLocalDatasource);

  @override
  List<Expense> getExpenseHistory(
      {required int count, bool descending = false}) {
    return expenseLocalDatasource.getExpensesFilter(count: count);
  }
}
