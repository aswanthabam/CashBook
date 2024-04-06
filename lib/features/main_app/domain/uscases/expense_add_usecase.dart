import 'package:cashbook/core/types/reponse_types.dart';
import 'package:cashbook/core/usecase/usecase.dart';
import 'package:cashbook/features/main_app/data/models/tag_data.dart';
import 'package:cashbook/features/main_app/domain/repositories/expense_repository.dart';
import 'package:fpdart/fpdart.dart%20%20';

class ExpenseAddUseCase
    implements UseCase<Success<int>, Failure, ExpenseAddParams> {
  final ExpenseRepository repository;

  ExpenseAddUseCase(this.repository);

  @override
  Future<Either<Success<int>, Failure>> call(ExpenseAddParams params) async {
    try {
      return left(Success<int>(
          "",
          await repository.addExpense(
              title: params.title,
              amount: params.amount,
              description: params.description,
              date: params.date,
              tags: params.tags)));
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
  final List<TagData> tags;

  ExpenseAddParams(
      {required this.title,
      required this.amount,
      required this.description,
      required this.date,
      required this.tags});
}