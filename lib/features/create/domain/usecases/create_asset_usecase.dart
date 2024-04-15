import 'package:cashbook/core/exceptions/datasource_expensions.dart';
import 'package:cashbook/core/types/reponse_types.dart';
import 'package:cashbook/core/usecase/usecase.dart';
import 'package:cashbook/data/models/asset.dart';
import 'package:cashbook/domain/repositories/assets_repository.dart';
import 'package:fpdart/fpdart.dart';

class CreateAssetUseCase implements UseCase<bool, Failure, Asset> {
  AssetsRepository repository;

  CreateAssetUseCase({required this.repository});

  @override
  Future<Either<bool, Failure>> call(Asset param) async {
    try {
      return left(repository.createAsset(param));
    } on LocalDatabaseException catch (e) {
      return right(Failure(e.message));
    }
  }
}
