import 'package:cashbook/core/exceptions/datasource_expensions.dart';
import 'package:cashbook/core/types/reponse_types.dart';
import 'package:cashbook/core/usecase/usecase.dart';
import 'package:cashbook/data/models/asset.dart';
import 'package:cashbook/domain/repositories/assets_repository.dart';
import 'package:fpdart/fpdart.dart';

class AssetsListUseCase
    implements UseCase<List<Asset>, Failure, AssetsListParams> {
  AssetsRepository repository;

  AssetsListUseCase({required this.repository});

  @override
  Future<Either<List<Asset>, Failure>> call(AssetsListParams param) async {
    try {
      return left(repository.getAssets(
          startDate: param.startDate,
          endDate: param.endDate,
          count: param.count));
    } on LocalDatabaseException catch (e) {
      return right(Failure(e.message));
    }
  }
}

class AssetsListParams {
  final DateTime? startDate;
  final DateTime? endDate;
  final int? count;

  AssetsListParams({this.startDate, this.endDate, this.count});
}
