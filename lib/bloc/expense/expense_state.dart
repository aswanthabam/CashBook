part of '../../../../../bloc/expense/expense_bloc.dart';

@immutable
sealed class ExpenseState {}

final class ExpenseInitial extends ExpenseState {}

/* Expense Data Related */

final class ExpenseDataLoaded extends ExpenseState {
  final List<Expense> expenses;
  final double total;

  ExpenseDataLoaded(this.expenses, this.total);
}

final class ExpenseDataError extends ExpenseState {
  final String message;

  ExpenseDataError(this.message);
}

/* Expense Add Related */

final class ExpenseAdded extends ExpenseState {}

final class ExpenseAddError extends ExpenseState {
  final String message;

  ExpenseAddError(this.message);
}

/* Expense Edit Related */

final class ExpenseEdited extends ExpenseState {}

final class ExpenseEditedError extends ExpenseState {
  final String message;

  ExpenseEditedError(this.message);
}
