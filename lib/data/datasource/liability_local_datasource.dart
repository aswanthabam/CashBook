import 'package:cashbook/core/datasource/local/database.dart';
import 'package:cashbook/core/exceptions/datasource_expensions.dart';
import 'package:cashbook/data/models/expense.dart';
import 'package:cashbook/data/models/liability.dart';
import 'package:cashbook/objectbox.g.dart';

abstract interface class LiabilityLocalDataSource {
  List<Liability> getLiabilities({int? count, bool includeFinished = false});

  bool addLiability(Liability asset);

  void editLiability(Liability liability);

  int payLiability(Liability liability, Expense expense);

  void editLiabilityPayment(int liabilityId, Expense expense, double newAmount);
}

class LiabilityLocalDataSourceImplementation
    implements LiabilityLocalDataSource {
  AppDatabase database;

  LiabilityLocalDataSourceImplementation({required this.database});

  @override
  bool addLiability(Liability liability) {
    try {
      database.insert<Liability>(liability);
      return true;
    } catch (e) {
      throw LocalDatabaseException(
          "An unexpected error occurred while adding liability!");
    }
  }

  @override
  List<Liability> getLiabilities({int? count, bool includeFinished = false}) {
    Box<Liability> box = database.box<Liability>();
    QueryBuilder<Liability> query;
    if (!includeFinished) {
      query = box.query(Liability_.remaining.greaterThan(0));
    } else {
      query = box.query();
    }
    Query<Liability> qu = query.build();
    if (count != null) {
      qu.limit = count;
    }
    return qu.find();
  }

  @override
  void editLiability(Liability liability) {
    try {
      database.box<Liability>().put(liability);
    } catch (e) {
      throw LocalDatabaseException(
          "An Unexpected error occurred while editing the liability");
    }
  }

  @override
  int payLiability(Liability liability, Expense expense) {
    try {
      liability.remaining -= expense.amount;
      liability.payouts.add(expense);
      database.box<Liability>().put(liability);
      return liability.id;
    } catch (e) {
      throw LocalDatabaseException(
          "An Unexpected error occurred while paying the liability");
    }
  }

  @override
  void editLiabilityPayment(
      int liabilityId, Expense expense, double newAmount) {
    try {
      Liability? liability = database.box<Liability>().get(liabilityId);
      if (liability == null) {
        throw LocalDatabaseException("Liability not found");
      }
      liability.remaining += expense.amount;
      liability.remaining -= newAmount;
      database.box<Liability>().put(liability);
    } catch (e) {
      throw LocalDatabaseException(
          "An Unexpected error occurred while paying the liability");
    }
  }
}
