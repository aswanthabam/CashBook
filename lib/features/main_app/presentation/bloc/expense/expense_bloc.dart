import 'package:cashbook/features/main_app/data/models/expense.dart';
import 'package:cashbook/features/main_app/data/models/tag_data.dart';
import 'package:cashbook/features/main_app/domain/uscases/expense_add_usecase.dart';
import 'package:cashbook/features/main_app/domain/uscases/expense_edit_usecase.dart';
import 'package:cashbook/features/main_app/domain/uscases/expense_history_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'expense_event.dart';
part 'expense_state.dart';

class ExpenseBloc extends Bloc<ExpenseEvent, ExpenseState> {
  final ExpenseDataUseCase _expenseHistoryUseCase;
  final ExpenseAddUseCase _expenseAddUseCase;
  final ExpenseEditUseCase _expenseEditUseCase;

  ExpenseBloc(
      {required ExpenseDataUseCase expenseHistoryUseCase,
      required ExpenseAddUseCase expenseAddUseCase,
      required ExpenseEditUseCase expenseEditUseCase})
      : _expenseHistoryUseCase = expenseHistoryUseCase,
        _expenseAddUseCase = expenseAddUseCase,
        _expenseEditUseCase = expenseEditUseCase,
        super(ExpenseInitial()) {
    on<EditExpenseEvent>((event, emit) {
      _expenseEditUseCase
          .call(ExpenseEditParams(
              id: event.id,
              title: event.title,
              amount: event.amount,
              description: event.description,
              date: event.date,
              tags: event.tags))
          .then((value) {
        value.fold((success) {
          emit(ExpenseEdited());
        }, (failure) {
          emit(ExpenseEditedError(failure.message));
        });
      });
    });
    on<AddExpenseEvent>((event, emit) {
      _expenseAddUseCase
          .call(ExpenseAddParams(
              title: event.title,
              amount: event.amount,
              description: event.description,
              date: event.date,
              tags: event.tags))
          .then((value) {
        value.fold((success) {
          emit(ExpenseAdded());
        }, (failure) {
          emit(ExpenseAddError(failure.message));
        });
      });
    });
    on<GetHistoryEvent>((event, emit) {
      _expenseHistoryUseCase(ExpenseHistoryParams(
              startDate: event.startDate, endDate: event.endDate))
          .then((value) {
        value.fold((success) {
          emit(ExpenseDataLoaded(
              success.payload.expenses, success.payload.total));
        }, (failure) {
          emit(ExpenseDataError(failure.message));
        });
      });
    });
  }
}
