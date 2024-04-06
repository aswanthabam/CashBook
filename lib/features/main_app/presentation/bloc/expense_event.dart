part of 'expense_bloc.dart';

@immutable
sealed class ExpenseEvent {}

final class GetHistoryEvent extends ExpenseEvent {
  final DateTime startDate;
  final DateTime endDate;

  GetHistoryEvent({required this.startDate, required this.endDate});
}

final class AddExpenseEvent extends ExpenseEvent {
  final String title;
  final double amount;
  final String description;
  final DateTime date;
  final List<int> tags;

  AddExpenseEvent(
      {required this.title,
      required this.amount,
      required this.description,
      required this.date,
      required this.tags});
}
