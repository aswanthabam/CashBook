import 'package:cashbook/core/datasource/local/database.dart';
import 'package:cashbook/core/exceptions/datasource_expensions.dart';
import 'package:cashbook/data/models/expense.dart';
import 'package:cashbook/data/models/liability.dart';
import 'package:cashbook/objectbox.g.dart';

abstract interface class LiabilityLocalDataSource {
  List<Liability> getLiabilities({int? count, bool includeFinished = false});

  bool addLiability(Liability asset);

  void editLiability({
    required int id,
    String? title,
    double? amount,
    String? description,
    DateTime? date,
    DateTime? endDate,
    double? remaining,
    String? icon,
    int? color,
    double? interest,
  });

  int payLiability(Liability liability, Expense expense);

  void editLiabilityPayment(
      Liability liability, Expense expense, double newAmount);

  Liability getLiability(int id);

  List<Expense> getLiabilityPayments(int id);
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
  void editLiability({
    required int id,
    String? title,
    double? amount,
    String? description,
    DateTime? date,
    DateTime? endDate,
    double? remaining,
    String? icon,
    int? color,
    double? interest,
  }) {
    try {
      Liability? Li = database.box<Liability>().get(id);
      if (Li == null) {
        throw LocalDatabaseException("Liability not found");
      }
      if (title != null) {
        Li.title = title;
      }
      if (amount != null) {
        Li.amount = amount;
      }
      if (description != null) {
        Li.description = description;
      }
      if (date != null) {
        Li.date = date;
      }
      if (endDate != null) {
        Li.endDate = endDate;
      }
      if (remaining != null) {
        Li.remaining = remaining;
      }
      if (icon != null) {
        Li.icon = icon;
      }
      if (color != null) {
        Li.color = color;
      }
      if (interest != null) {
        Li.interest = interest;
      }
      database.box<Liability>().put(Li);
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
  void editLiabilityPayment(Liability liability, Expense expense,
      double newAmount) {
    try {
      liability.remaining += expense.amount;
      liability.remaining -= newAmount;
      database.box<Liability>().put(liability);
    } catch (e) {
      throw LocalDatabaseException(
          "An Unexpected error occurred while paying the liability");
    }
  }

  @override
  Liability getLiability(int id) {
    try {
      Liability? liability = database.box<Liability>().get(id);
      if (liability == null) {
        throw LocalDatabaseException("Liability not found");
      }
      return liability;
    } catch (e) {
      throw LocalDatabaseException(
          "An Unexpected error occurred while getting the liability");
    }
  }

  @override
  List<Expense> getLiabilityPayments(int id) {
    try {
      Liability? liability = database.box<Liability>().get(id);
      if (liability == null) {
        throw LocalDatabaseException("Liability not found");
      }
      return liability.payouts;
    } catch (e) {
      throw LocalDatabaseException(
          "An Unexpected error occurred while getting the liability payments");
    }
  }
}
