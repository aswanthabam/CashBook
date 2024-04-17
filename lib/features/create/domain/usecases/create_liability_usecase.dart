import 'package:cashbook/core/exceptions/datasource_expensions.dart';
import 'package:cashbook/core/types/reponse_types.dart';
import 'package:cashbook/core/usecase/usecase.dart';
import 'package:cashbook/data/models/liability.dart';
import 'package:cashbook/domain/repositories/liability_repository.dart';
import 'package:fpdart/fpdart.dart';

class CreateLiabilityUseCase implements UseCase<bool, Failure, Liability> {
  LiabilityRepository repository;

  CreateLiabilityUseCase({required this.repository});

  @override
  Future<Either<bool, Failure>> call(Liability param) async {
    try {
      repository.createLiability(param);
      return left(true);
    } on LocalDatabaseException catch (e) {
      return right(Failure(e.message));
    }
  }
}
