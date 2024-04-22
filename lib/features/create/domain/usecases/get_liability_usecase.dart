import 'package:cashbook/core/exceptions/datasource_expensions.dart';
import 'package:cashbook/core/types/reponse_types.dart';
import 'package:cashbook/core/usecase/usecase.dart';
import 'package:cashbook/data/models/liability.dart';
import 'package:cashbook/domain/repositories/liability_repository.dart';
import 'package:fpdart/src/either.dart';

final class GetLiabilityUseCase implements UseCase<Liability, Failure, int> {
  final LiabilityRepository repository;

  GetLiabilityUseCase({required this.repository});

  @override
  Future<Either<Liability, Failure>> call(int param) async {
    try {
      return left(repository.getLiability(param));
    } on LocalDatabaseException catch (e) {
      return right(Failure(e.message));
    }
  }
}
