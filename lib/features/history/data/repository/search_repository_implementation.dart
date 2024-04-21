import 'package:cashbook/data/datasource/expense_local_datasource.dart';
import 'package:cashbook/data/models/expense.dart';
import 'package:cashbook/features/history/domain/repository/search_repository.dart';

class SearchRepositoryImplementation implements SearchRepository {
  ExpenseLocalDatasource datasource;

  SearchRepositoryImplementation({required this.datasource});

  @override
  List<Expense> searchExpense({required String query}) {
    return datasource.searchExpense(query: query);
  }
}
