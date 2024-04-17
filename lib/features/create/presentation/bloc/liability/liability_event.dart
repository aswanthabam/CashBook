part of 'liability_bloc.dart';

@immutable
sealed class LiabilityEvent {}

final class CreateLiabilityEvent extends LiabilityEvent {
  final String title;
  final double amount;
  final double remaining;
  final double interest;
  final String? description;
  final TagData? tag;
  final DateTime date;
  final DateTime? endDate;

  CreateLiabilityEvent(
      {required this.title,
      required this.amount,
      required this.remaining,
      required this.interest,
      required this.description,
      required this.tag,
      required this.date,
      required this.endDate});
}
