part of 'expense_bloc.dart';

@immutable
sealed class ExpenseState {}

final class ExpenseInitial extends ExpenseState {}

final class ExpenseHistoryLoaded extends ExpenseState {
  final List<Expense> expenses;

  ExpenseHistoryLoaded(this.expenses);
}

final class ExpenseHistoryError extends ExpenseState {
  final String message;

  ExpenseHistoryError(this.message);
}
