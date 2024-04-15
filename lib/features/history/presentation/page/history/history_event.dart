part of 'history_bloc.dart';

@immutable
sealed class HistoryEvent {}

final class GetHistoryEvent extends HistoryEvent {
  final int count;
  final DateTime? startDate;
  final DateTime? endDate;

  GetHistoryEvent({required this.count, this.startDate, this.endDate});
}

final class SearchHistoryEvent extends HistoryEvent {
  final String query;

  SearchHistoryEvent({required this.query});
}
