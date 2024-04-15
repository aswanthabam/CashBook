part of 'history_bloc.dart';

@immutable
sealed class HistoryState {}

final class HistoryInitial extends HistoryState {}

final class HistoryLoaded extends HistoryState {
  final List<Expense> expenses;

  HistoryLoaded(this.expenses);
}

final class HistoryError extends HistoryState {
  final String message;

  HistoryError(this.message);

  @override
  String toString() {
    return this.message;
  }
}
