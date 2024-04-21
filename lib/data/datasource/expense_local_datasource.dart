import 'package:cashbook/core/datasource/local/database.dart';
import 'package:cashbook/core/exceptions/datasource_expensions.dart';
import 'package:cashbook/data/models/expense.dart';
import 'package:cashbook/data/models/tag_data.dart';
import 'package:cashbook/objectbox.g.dart';

abstract interface class ExpenseLocalDatasource {
  Future<int> addExpense({
    required String title,
    required double amount,
    required String description,
    required DateTime date,
    required TagData? tag,
  });

  Future<void> deleteExpense({required int id});

  Future<int> updateExpense({
    required int id,
    String? title,
    double? amount,
    String? description,
    DateTime? date,
    TagData? tag,
  });

  List<Expense> getExpensesFilter({required int count,
    DateTime? startDate,
    DateTime? endDate,
    bool descending = false});

  double totalExpense();

  double totalExpenseFilter(
      {required DateTime startDate, required DateTime endDate});

  List<Expense> getExpenseList(
      {required DateTime startDate,
      required DateTime endDate,
      bool descending = false});

  List<Expense> searchExpense({required String query});
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
      required TagData? tag}) async {
    Expense entity = Expense(
      id: 0,
      title: title,
      amount: amount,
      description: description,
      date: date,
    );
    if (tag != null) entity.tag.target = tag;

    try {
      return database.insert<Expense>(entity);
    } catch (e) {
      print(e);
      throw LocalDatabaseException(
          "Error adding expense, an unexpected error occurred");
    }
  }

  @override
  Future<void> deleteExpense({required int id}) {
    throw UnimplementedError();
  }

  @override
  List<Expense> getExpensesFilter({required int count,
    DateTime? startDate,
    DateTime? endDate,
    bool descending = false}) {
    try {
      Box<Expense> box = database.box<Expense>();
      QueryBuilder<Expense> query;
      if (startDate != null && endDate != null) {
        query = box.query(Expense_.date.between(
            startDate.millisecondsSinceEpoch, endDate.millisecondsSinceEpoch));
      } else if (startDate != null) {
        query = box
            .query(Expense_.date.greaterThan(startDate.millisecondsSinceEpoch));
      } else if (endDate != null) {
        query =
            box.query(Expense_.date.lessThan(endDate.millisecondsSinceEpoch));
      } else {
        query = box.query();
      }
      query.order(Expense_.date, flags: descending ? 1 : 0);
      Query<Expense> qu = query.build();
      qu.limit = -count;
      return qu.find();
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
      TagData? tag}) async {
    try {
      Expense? entity = database.box<Expense>().get(id);
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
      entity.tag.target = tag;
      database.box<Expense>().put(entity);
      return entity.id;
    } catch (e) {
      throw LocalDatabaseException(
          "Error updating expense, an unexpected error occurred");
    }
  }

  @override
  List<Expense> getExpenseList(
      {required DateTime startDate,
      required DateTime endDate,
      bool descending = false}) {
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
  List<Expense> searchExpense({required String query}) {
    try {
      List<TagData> tags = database
          .box<TagData>()
          .query(TagData_.title.contains(query, caseSensitive: false))
          .build()
          .find();
      print(tags);
      Query<Expense> q = database
          .box<Expense>()
          .query(Expense_.title
              .contains(query, caseSensitive: false)
              .or(Expense_.description.contains(query, caseSensitive: false)))
          .build();
      return q.find();
    } catch (e) {
      throw LocalDatabaseException(
          "Error searching expenses, an unexpected error occurred");
    }
  }
}
