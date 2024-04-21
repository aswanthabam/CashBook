import 'package:cashbook/data/models/expense.dart';

abstract interface class SearchRepository {
  List<Expense> searchExpense({required String query});
}
