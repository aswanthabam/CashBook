part of 'expense_bloc.dart';

@immutable
sealed class ExpenseState {}

final class ExpenseInitial extends ExpenseState {}

final class ExpenseDataLoaded extends ExpenseState {
  final List<Expense> expenses;
  final double total;

  ExpenseDataLoaded(this.expenses, this.total);
}

final class ExpenseDataError extends ExpenseState {
  final String message;

  ExpenseDataError(this.message);
}

final class ExpenseAdded extends ExpenseState {}

final class ExpenseAddError extends ExpenseState {
  final String message;

  ExpenseAddError(this.message);
}

final class GotTotalExpense extends ExpenseState {
  final double value;

  GotTotalExpense(this.value);
}

final class TotalExpenseError extends ExpenseState {
  final String message;

  TotalExpenseError(this.message);
}