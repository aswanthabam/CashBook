import 'package:cashbook/core/exceptions/datasource_expensions.dart';
import 'package:cashbook/core/types/reponse_types.dart';
import 'package:cashbook/core/usecase/usecase.dart';
import 'package:cashbook/data/models/expense.dart';
import 'package:cashbook/domain/repositories/liability_repository.dart';
import 'package:fpdart/fpdart.dart';

final class LiabilityPayoutsUseCase
    implements UseCase<List<Expense>, Failure, int> {
  final LiabilityRepository repository;

  LiabilityPayoutsUseCase({required this.repository});

  @override
  Future<Either<List<Expense>, Failure>> call(int param) async {
    try {
      return left(repository.getLiabilityPayments(param));
    } on LocalDatabaseException catch (e) {
      return right(Failure(e.message));
    }
  }
}
