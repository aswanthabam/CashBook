part of 'liability_bloc.dart';

@immutable
sealed class LiabilityEvent {}

final class CreateLiabilityEvent extends LiabilityEvent {
  final String title;
  final double amount;
  final double remaining;
  final double interest;
  final String? description;
  final int color;
  final String? icon;
  final DateTime date;
  final DateTime? endDate;

  CreateLiabilityEvent(
      {required this.title,
      required this.amount,
      required this.remaining,
      required this.interest,
      required this.description,
      required this.icon,
      this.color = 0xff0000ff,
      required this.date,
      required this.endDate});
}
