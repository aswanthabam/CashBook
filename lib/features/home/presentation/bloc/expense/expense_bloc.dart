import 'package:cashbook/features/home/data/models/expense.dart';
import 'package:cashbook/features/home/data/models/tag_data.dart';
import 'package:cashbook/features/home/domain/uscases/expense_add_usecase.dart';
import 'package:cashbook/features/home/domain/uscases/expense_edit_usecase.dart';
import 'package:cashbook/features/home/domain/uscases/expense_total_data_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'expense_event.dart';
part 'expense_state.dart';

class ExpenseBloc extends Bloc<ExpenseEvent, ExpenseState> {
  final ExpenseAddUseCase _expenseAddUseCase;
  final ExpenseEditUseCase _expenseEditUseCase;
  final ExpenseTotalDataUseCase _expenseTotalDataUseCase;

  ExpenseBloc({
    required ExpenseAddUseCase expenseAddUseCase,
    required ExpenseEditUseCase expenseEditUseCase,
    required ExpenseTotalDataUseCase expenseTotalDataUseCase,
  })  : _expenseAddUseCase = expenseAddUseCase,
        _expenseEditUseCase = expenseEditUseCase,
        _expenseTotalDataUseCase = expenseTotalDataUseCase,
        super(ExpenseInitial()) {
    // Expense Edit Event
    on<EditExpenseEvent>((event, emit) {
      _expenseEditUseCase
          .call(ExpenseEditParams(
              id: event.id,
              title: event.title,
              amount: event.amount,
              description: event.description,
              date: event.date,
              tag: event.tag))
          .then((value) {
        value.fold((success) {
          emit(ExpenseEdited());
        }, (failure) {
          emit(ExpenseEditedError(failure.message));
        });
      });
    });
    // Expense Add Event
    on<AddExpenseEvent>((event, emit) {
      _expenseAddUseCase
          .call(ExpenseAddParams(
              title: event.title,
              amount: event.amount,
              description: event.description,
              date: event.date,
              tag: event.tag))
          .then((value) {
        value.fold((success) {
          emit(ExpenseAdded());
        }, (failure) {
          emit(ExpenseAddError(failure.message));
        });
      });
    });
    // Expense Data Event, gives total and daily expenses
    on<ExpenseDataEvent>((event, emit) {
      _expenseTotalDataUseCase(ExpenseTotalDataParams(
              startDate: event.startDate, endDate: event.endDate))
          .then((value) {
        value.fold((success) {
          emit(ExpenseDataLoaded(success.dailyExpenses, success.total));
        }, (failure) {
          emit(ExpenseDataError(failure.message));
        });
      });
    });
  }
}
