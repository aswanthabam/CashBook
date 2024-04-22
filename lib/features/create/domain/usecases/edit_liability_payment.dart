import 'package:cashbook/core/types/reponse_types.dart';
import 'package:cashbook/core/usecase/usecase.dart';
import 'package:cashbook/data/models/expense.dart';
import 'package:cashbook/domain/repositories/liability_repository.dart';
import 'package:fpdart/src/either.dart';

class EditLiabilityPaymentUseCase
    implements UseCase<bool, Failure, EditLiabilityPaymentParams> {
  LiabilityRepository repository;

  EditLiabilityPaymentUseCase({required this.repository});

  @override
  Future<Either<bool, Failure>> call(EditLiabilityPaymentParams param) async {
    try {
      repository.editLiabilityPayment(
          param.liabilityId, param.expense, param.newAmount);
      return Left(true);
    } catch (e) {
      return Right(Failure('Failed to edit liability payment'));
    }
  }
}

final class EditLiabilityPaymentParams {
  final int liabilityId;
  final Expense expense;
  final double newAmount;

  EditLiabilityPaymentParams(
      {required this.liabilityId,
      required this.expense,
      required this.newAmount});
}
