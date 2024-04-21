import 'package:cashbook/core/exceptions/datasource_expensions.dart';
import 'package:cashbook/core/types/reponse_types.dart';
import 'package:cashbook/core/usecase/usecase.dart';
import 'package:cashbook/data/models/liability.dart';
import 'package:cashbook/domain/repositories/liability_repository.dart';
import 'package:fpdart/fpdart.dart';

class LiabilityListUseCase
    implements UseCase<List<Liability>, Failure, LiabilityListParams> {
  LiabilityRepository repository;

  LiabilityListUseCase({required this.repository});

  @override
  Future<Either<List<Liability>, Failure>> call(
      LiabilityListParams param) async {
    try {
      return left(repository.getLiabilities(count: param.count));
    } on LocalDatabaseException catch (e) {
      return right(Failure(e.message));
    }
  }
}

class LiabilityListParams {
  final int? count;
  final bool includeFinished;

  LiabilityListParams({required this.count, required this.includeFinished});
}
