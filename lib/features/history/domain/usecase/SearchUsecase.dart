import 'package:cashbook/core/exceptions/datasource_expensions.dart';
import 'package:cashbook/core/types/reponse_types.dart';
import 'package:cashbook/core/usecase/usecase.dart';
import 'package:cashbook/data/models/expense.dart';
import 'package:cashbook/features/history/domain/repository/search_repository.dart';
import 'package:fpdart/src/either.dart';

class SearchUseCase
    implements UseCase<List<Expense>, Failure, SearchUseCaseParams> {
  final SearchRepository repository;

  const SearchUseCase({required this.repository});

  @override
  Future<Either<List<Expense>, Failure>> call(SearchUseCaseParams param) async {
    try {
      return left(repository.searchExpense(query: param.query));
    } on LocalDatabaseException catch (e) {
      return right(Failure(e.message));
    }
  }
}

class SearchUseCaseParams {
  final String query;

  SearchUseCaseParams({required this.query});
}
