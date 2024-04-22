part of 'liability_bloc.dart';

@immutable
sealed class LiabilityState {}

final class LiabilityInitial extends LiabilityState {}

final class LiabilityCreated extends LiabilityState {}

final class LiabilityCreationError extends LiabilityState {
  final String message;

  LiabilityCreationError({required this.message});
}

final class LiabilityEdited extends LiabilityState {}

final class LiabilityEditError extends LiabilityState {
  final String message;

  LiabilityEditError({required this.message});
}
