part of 'expense_bloc.dart';

@immutable
sealed class ExpenseEvent {}

final class ExpenseDataEvent extends ExpenseEvent {
  final DateTime startDate;
  final DateTime endDate;

  ExpenseDataEvent({required this.startDate, required this.endDate});
}

final class AddExpenseEvent extends ExpenseEvent {
  final String title;
  final double amount;
  final String description;
  final DateTime date;
  final TagData? tag;

  AddExpenseEvent(
      {required this.title,
      required this.amount,
      required this.description,
      required this.date,
      required this.tag});
}

final class EditExpenseEvent extends ExpenseEvent {
  final String title;
  final double amount;
  final String description;
  final DateTime date;
  final TagData? tag;
  final int id;

  EditExpenseEvent(
      {required this.title,
      required this.amount,
      required this.description,
      required this.date,
      required this.tag,
      required this.id});
}
