part of 'expense_analytics_bloc.dart';

@immutable
sealed class ExpenseAnalyticsState {}

final class ExpenseAnalyticsInitial extends ExpenseAnalyticsState {}

class ExpenseTagsAnalyticsLoaded extends ExpenseAnalyticsEvent {
  final List<Expense> tags;

  ExpenseTagsAnalyticsLoaded(this.tags);
}
