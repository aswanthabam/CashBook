part of 'expense_history_bloc.dart';

@immutable
sealed class ExpenseHistoryState {}

final class ExpenseHistoryInitial extends ExpenseHistoryState {}

/* Expense History Related */

final class ExpenseHistoryLoaded extends ExpenseHistoryState {
  final List<Expense> expenses;

  ExpenseHistoryLoaded(this.expenses);
}

final class ExpenseHistoryError extends ExpenseHistoryState {
  final String message;

  ExpenseHistoryError(this.message);
}
