import 'package:cashbook/features/main_app/data/models/expense.dart';
import 'package:cashbook/features/main_app/domain/uscases/expense_history_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'expense_event.dart';
part 'expense_state.dart';

class ExpenseBloc extends Bloc<ExpenseEvent, ExpenseState> {
  final ExpenseHistoryUseCase _expenseHistoryUseCase;

  ExpenseBloc({required ExpenseHistoryUseCase expenseHistoryUseCase})
      : _expenseHistoryUseCase = expenseHistoryUseCase,
        super(ExpenseInitial()) {
    on<GetHistoryEvent>((event, emit) {
      _expenseHistoryUseCase(ExpenseHistoryParams(
              startDate: event.startDate, endDate: event.endDate))
          .then((value) {
        value.fold((success) {
          emit(ExpenseHistoryLoaded(success.payload));
        }, (failure) {
          emit(ExpenseHistoryError(failure.message));
        });
      });
    });
  }
}
