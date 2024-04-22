import 'package:cashbook/core/exceptions/datasource_expensions.dart';
import 'package:cashbook/core/types/reponse_types.dart';
import 'package:cashbook/core/usecase/usecase.dart';
import 'package:cashbook/data/models/expense.dart';
import 'package:cashbook/data/models/liability.dart';
import 'package:cashbook/domain/repositories/liability_repository.dart';
import 'package:fpdart/src/either.dart';

class PayLiabilityUseCase
    implements UseCase<bool, Failure, PayLiabilityParams> {
  LiabilityRepository repository;

  PayLiabilityUseCase({required this.repository});

  @override
  Future<Either<bool, Failure>> call(PayLiabilityParams param) async {
    try {
      repository.payLiability(param.liability, param.expense);
      return left(true);
    } on LocalDatabaseException catch (e) {
      return right(Failure(e.message));
    }
  }
}

class PayLiabilityParams {
  Liability liability;
  Expense expense;

  PayLiabilityParams({required this.liability, required this.expense});
}
