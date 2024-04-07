import 'package:cashbook/core/datasource/local/database.dart';
import 'package:cashbook/core/exceptions/datasource_expensions.dart';
import 'package:cashbook/features/main_app/data/models/expense.dart';
import 'package:cashbook/features/main_app/data/models/tag_data.dart';
import 'package:cashbook/objectbox.g.dart';

abstract interface class ExpenseLocalDatasource {
  Future<int> addExpense({
    required String title,
    required double amount,
    required String description,
    required DateTime date,
    required List<TagData> tags,
  });

  Future<void> deleteExpense({required int id});

  Future<int> updateExpense({
    required int id,
    String? title,
    double? amount,
    String? description,
    DateTime? date,
    List<TagData>? tags,
  });

  Future<List<Expense>> getExpensesFilter(
      {required DateTime startDate,
      required DateTime endDate,
      bool descending = false});

  double totalExpense();

  double totalExpenseFilter(
      {required DateTime startDate, required DateTime endDate});
}

class ExpenseLocalDatasourceImplementation implements ExpenseLocalDatasource {
  final AppDatabase database;

  ExpenseLocalDatasourceImplementation(this.database);

  @override
  Future<int> addExpense(
      {required String title,
      required double amount,
      required String description,
      required DateTime date,
      required List<TagData> tags}) async {
    Expense entity = Expense(
      id: 0,
      title: title,
      amount: amount,
      description: description,
      date: date,
    );
    entity.tags.addAll(tags);
    try {
      return database.insert<Expense>(entity);
    } catch (e) {
      throw LocalDatabaseException(
          "Error adding expense, an unexpected error occurred");
    }
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
    try {
      Query<Expense> query = database
          .box<Expense>()
          .query(Expense_.date.between(
              startDate.millisecondsSinceEpoch, endDate.millisecondsSinceEpoch))
          .order(Expense_.date, flags: descending ? 1 : 0)
          .build();
      return query.find();
    } catch (e) {
      throw LocalDatabaseException(
          "Error getting expenses, an unexpected error occurred");
    }
  }

  @override
  double totalExpense() {
    try {
      Query<Expense> query = database.box<Expense>().query().build();
      return query.property(Expense_.amount).sum();
    } catch (e) {
      throw LocalDatabaseException(
          "Error getting total expenses, an unexpected error occurred");
    }
  }

  @override
  double totalExpenseFilter(
      {required DateTime startDate, required DateTime endDate}) {
    try {
      Query<Expense> query = database
          .box<Expense>()
          .query(Expense_.date.between(
              startDate.millisecondsSinceEpoch, endDate.millisecondsSinceEpoch))
          .build();
      return query.property(Expense_.amount).sum();
      // return query.property(Expense_.amount);
    } catch (e) {
      throw LocalDatabaseException(
          "Error getting total expenses, an unexpected error occurred");
    }
  }

  @override
  Future<int> updateExpense(
      {required int id,
      String? title,
      double? amount,
      String? description,
      DateTime? date,
      List<TagData>? tags}) async {
    try {
      Expense entity = database.box<Expense>().get(id);
      if (entity == null) {
        throw LocalDatabaseException("Expense not found");
      }
      if (title != null) {
        entity.title = title;
      }
      if (amount != null) {
        entity.amount = amount;
      }
      if (description != null) {
        entity.description = description;
      }
      if (date != null) {
        entity.date = date;
      }
      if (tags != null) {
        entity.tags.clear();
        entity.tags.addAll(tags);
      }
      database.box<Expense>().put(entity);
      return entity.id;
    } catch (e) {
      throw LocalDatabaseException(
          "Error updating expense, an unexpected error occurred");
    }
  }
}
