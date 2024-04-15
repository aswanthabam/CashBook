import 'package:cashbook/data/datasource/expense_local_datasource.dart';
import 'package:cashbook/data/models/expense.dart';
import 'package:cashbook/features/home/domain/repositories/expense_history_repository.dart';

class ExpenseHistoryRepositoryImplementation
    implements ExpenseHistoryRepository {
  final ExpenseLocalDatasource expenseLocalDatasource;

  const ExpenseHistoryRepositoryImplementation(this.expenseLocalDatasource);

  @override
  List<Expense> getExpenseHistory({required int count,
    DateTime? startDate,
    DateTime? endDate,
    bool descending = false}) {
    return expenseLocalDatasource.getExpensesFilter(
        count: count,
        startDate: startDate,
        endDate: endDate,
        descending: descending);
  }
}
