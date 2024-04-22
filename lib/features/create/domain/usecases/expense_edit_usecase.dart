import 'package:cashbook/core/exceptions/datasource_expensions.dart';
import 'package:cashbook/core/types/reponse_types.dart';
import 'package:cashbook/core/usecase/usecase.dart';
import 'package:cashbook/data/models/expense.dart';
import 'package:cashbook/data/models/tag_data.dart';
import 'package:cashbook/domain/repositories/expense_repository.dart';
import 'package:fpdart/fpdart.dart%20%20';

class ExpenseEditUseCase
    implements UseCase<Expense, Failure, ExpenseEditParams> {
  final ExpenseRepository repository;

  ExpenseEditUseCase(this.repository);

  @override
  Future<Either<Expense, Failure>> call(ExpenseEditParams params) async {
    try {
      return left(await repository.updateExpense(
          id: params.id,
          title: params.title,
          amount: params.amount,
          description: params.description,
          date: params.date,
          tag: params.tag));
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
