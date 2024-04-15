import 'package:cashbook/core/datasource/local/database.dart';
import 'package:cashbook/core/exceptions/datasource_expensions.dart';
import 'package:cashbook/data/models/asset.dart';
import 'package:cashbook/objectbox.g.dart';

abstract interface class AssetLocalDataSource {
  List<Asset> getAssets({DateTime? startDate, DateTime? endDate, int? count});

  bool createAsset(Asset asset);
}

class AssetLocalDataSourceImplementation implements AssetLocalDataSource {
  AppDatabase database;

  AssetLocalDataSourceImplementation({required this.database});

  @override
  bool createAsset(Asset asset) {
    try {
      database.insert<Asset>(asset);
      return true;
    } catch (e) {
      throw LocalDatabaseException(
          "An unexpected error occurred while adding asset!");
    }
  }

  @override
  List<Asset> getAssets({DateTime? startDate, DateTime? endDate, int? count}) {
    Box<Asset> box = database.box<Asset>();
    QueryBuilder<Asset> query;
    if (startDate != null && endDate != null) {
      query = box.query(Asset_.date.between(
          startDate.millisecondsSinceEpoch, endDate.millisecondsSinceEpoch));
    } else if (startDate != null) {
      query =
          box.query(Asset_.date.greaterThan(startDate.millisecondsSinceEpoch));
    } else if (endDate != null) {
      query = box.query(Asset_.date.lessThan(endDate.millisecondsSinceEpoch));
    } else {
      query = box.query();
    }
    Query<Asset> qu = query.build();
    if (count != null) {
      qu.limit = count;
    }
    return qu.find();
  }
}
