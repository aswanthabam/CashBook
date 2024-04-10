import 'package:bloc/bloc.dart';
import 'package:cashbook/features/home/data/models/expense.dart';
import 'package:cashbook/features/home/domain/uscases/expense_history_usecase.dart';
import 'package:meta/meta.dart';

part 'expense_history_event.dart';
part 'expense_history_state.dart';

class ExpenseHistoryBloc
    extends Bloc<ExpenseHistoryEvent, ExpenseHistoryState> {
  final ExpenseHistoryUseCase _expenseHistoryUseCase;

  ExpenseHistoryBloc({required ExpenseHistoryUseCase expenseHistoryUseCase})
      : _expenseHistoryUseCase = expenseHistoryUseCase,
        super(ExpenseHistoryInitial()) {
    // Expense History Event
    on<GetExpenseHistoryEvent>((event, emit) {
      _expenseHistoryUseCase
          .call(ExpenseHistoryParams(count: event.count, descending: false))
          .then((value) {
        value.fold((expenses) {
          emit(ExpenseHistoryLoaded(expenses));
        }, (failure) {
          emit(ExpenseHistoryError(failure.message));
        });
      });
    });
  }
}
