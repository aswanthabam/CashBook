part of 'expense_history_bloc.dart';

@immutable
sealed class ExpenseHistoryEvent {}

final class GetExpenseHistoryEvent extends ExpenseHistoryEvent {
  final int count;

  GetExpenseHistoryEvent({required this.count});
}
