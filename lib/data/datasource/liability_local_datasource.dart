import 'package:cashbook/core/datasource/local/database.dart';
import 'package:cashbook/core/exceptions/datasource_expensions.dart';
import 'package:cashbook/data/models/liability.dart';
import 'package:cashbook/objectbox.g.dart';

abstract interface class LiabilityLocalDataSource {
  List<Liability> getLiabilities({int? count, bool includeFinished = false});

  bool addLiability(Liability asset);
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
    print("HERREEEE");
    Query<Liability> qu = query.build();
    if (count != null) {
      qu.limit = count;
    }
    return qu.find();
  }
}
