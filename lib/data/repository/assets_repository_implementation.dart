import 'package:cashbook/data/datasource/asset_local_datasource.dart';
import 'package:cashbook/data/models/asset.dart';
import 'package:cashbook/domain/repositories/assets_repository.dart';

class AssetsRepositoryImplementation implements AssetsRepository {
  final AssetLocalDataSource assetsDataSource;

  AssetsRepositoryImplementation({required this.assetsDataSource});

  @override
  bool createAsset(Asset asset) {
    return assetsDataSource.createAsset(asset);
  }

  @override
  List<Asset> getAssets({DateTime? startDate, DateTime? endDate, int? count}) {
    return assetsDataSource.getAssets(
        startDate: startDate, endDate: endDate, count: count);
  }
}
