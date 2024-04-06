part of 'expense_bloc.dart';

@immutable
sealed class ExpenseEvent {}

final class GetHistoryEvent extends ExpenseEvent {
  final DateTime startDate;
  final DateTime endDate;

  GetHistoryEvent({required this.startDate, required this.endDate});
}
