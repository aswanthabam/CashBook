part of 'expense_analytics_bloc.dart';

@immutable
sealed class ExpenseAnalyticsEvent {}

class ExpenseTagsAnalyticsEvent extends ExpenseAnalyticsEvent {
  ExpenseTagsAnalyticsEvent();
}
