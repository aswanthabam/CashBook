import 'package:cashbook/data/models/asset.dart';

abstract interface class AssetsRepository {
  List<Asset> getAssets({DateTime? startDate, DateTime? endDate, int? count});

  bool createAsset(Asset asset);
}
