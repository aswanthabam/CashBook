import 'package:cashbook/core/exceptions/datasource_expensions.dart';
import 'package:cashbook/core/types/reponse_types.dart';
import 'package:cashbook/core/usecase/usecase.dart';
import 'package:cashbook/features/main_app/data/models/tag_data.dart';
import 'package:cashbook/features/main_app/domain/repositories/expense_repository.dart';
import 'package:fpdart/fpdart.dart%20%20';

class ExpenseEditUseCase
    implements UseCase<Success<int>, Failure, ExpenseEditParams> {
  final ExpenseRepository repository;

  ExpenseEditUseCase(this.repository);

  @override
  Future<Either<Success<int>, Failure>> call(ExpenseEditParams params) async {
    try {
      return left(Success<int>(
          "",
          await repository.updateExpense(
              id: params.id,
              title: params.title,
              amount: params.amount,
              description: params.description,
              date: params.date,
              tag: params.tag)));
    } on LocalDatabaseException catch (e) {
      return right(Failure(e.message));
    }
  }
}

class ExpenseEditParams {
  final int id;
  final String title;
  final double amount;
  final String description;
  final DateTime date;
  final TagData? tag;

  ExpenseEditParams(
      {required this.id,
      required this.title,
      required this.amount,
      required this.description,
      required this.date,
      required this.tag});
}
