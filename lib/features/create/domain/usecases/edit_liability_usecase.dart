import 'package:cashbook/core/exceptions/datasource_expensions.dart';
import 'package:cashbook/core/types/reponse_types.dart';
import 'package:cashbook/core/usecase/usecase.dart';
import 'package:cashbook/domain/repositories/liability_repository.dart';
import 'package:fpdart/fpdart.dart';

class EditLiabilityUseCase
    implements UseCase<bool, Failure, LiabilityEditParams> {
  LiabilityRepository repository;

  EditLiabilityUseCase({required this.repository});

  @override
  Future<Either<bool, Failure>> call(LiabilityEditParams param) async {
    try {
      repository.editLiability(
        id: param.id,
        title: param.title,
        amount: param.amount,
        description: param.description,
        date: param.date,
        endDate: param.endDate,
        remaining: param.remaining,
        icon: param.icon,
        color: param.color,
        interest: param.interest,
      );
      return left(true);
    } on LocalDatabaseException catch (e) {
      return right(Failure(e.message));
    }
  }
}

class LiabilityEditParams {
  final int id;
  final String? title;
  final double? amount;
  final String? description;
  final DateTime? date;
  final DateTime? endDate;
  final double? remaining;
  final String? icon;
  final int? color;
  final double? interest;

  LiabilityEditParams(
      {required this.id,
      this.title,
      this.amount,
      this.description,
      this.date,
      this.endDate,
      this.remaining,
      this.icon,
      this.color,
      this.interest});
}
