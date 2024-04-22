import 'package:cashbook/core/types/reponse_types.dart';
import 'package:cashbook/core/usecase/usecase.dart';
import 'package:cashbook/data/models/expense.dart';
import 'package:cashbook/data/models/liability.dart';
import 'package:cashbook/data/models/tag_data.dart';
import 'package:cashbook/domain/repositories/expense_repository.dart';
import 'package:fpdart/fpdart.dart%20%20';

class ExpenseAddUseCase implements UseCase<Expense, Failure, ExpenseAddParams> {
  final ExpenseRepository repository;

  ExpenseAddUseCase(this.repository);

  @override
  Future<Either<Expense, Failure>> call(ExpenseAddParams params) async {
    try {
      return left(await repository.addExpense(
          title: params.title,
          amount: params.amount,
          description: params.description,
          date: params.date,
          tag: params.tag,
          liability: params.liability));
    } catch (e) {
      return right(Failure("An error occurred"));
    }
  }
}

class ExpenseAddParams {
  final String title;
  final double amount;
  final String description;
  final DateTime date;
  final TagData? tag;
  final Liability? liability;

  ExpenseAddParams(
      {required this.title,
      required this.amount,
      required this.description,
      required this.date,
      required this.tag,
      this.liability});
}
