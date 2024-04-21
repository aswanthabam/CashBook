import 'package:bloc/bloc.dart';
import 'package:cashbook/data/models/expense.dart';
import 'package:cashbook/features/history/domain/usecase/SearchUsecase.dart';
import 'package:cashbook/features/home/domain/uscases/expense_history_usecase.dart';
import 'package:meta/meta.dart';

part 'history_event.dart';
part 'history_state.dart';

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  ExpenseHistoryUseCase _expenseHistoryUseCase;
  SearchUseCase _searchUseCase;

  HistoryBloc({
    required ExpenseHistoryUseCase expenseHistoryUseCase,
    required SearchUseCase searchUseCase,
  })  : this._expenseHistoryUseCase = expenseHistoryUseCase,
        this._searchUseCase = searchUseCase,
        super(HistoryInitial()) {
    on<GetHistoryEvent>((event, emit) {
      _expenseHistoryUseCase
          .call(ExpenseHistoryParams(
              count: event.count,
              startDate: event.startDate,
              endDate: event.endDate,
              descending: false))
          .then((value) {
        value.fold((expenses) {
          emit(HistoryLoaded(expenses));
        }, (failure) {
          emit(HistoryError(failure.message));
        });
      });
    });

    on<SearchHistoryEvent>((event, emit) {
      _searchUseCase
          .call(SearchUseCaseParams(query: event.query))
          .then((value) {
        value.fold((expenses) {
          emit(HistoryLoaded(expenses));
        }, (failure) {
          emit(HistoryError(failure.message));
        });
      });
    });
  }
}
