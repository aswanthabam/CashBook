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

final class LiabilityPaid extends LiabilityState {}

final class LiabilityPayError extends LiabilityState {
  final String message;

  LiabilityPayError({required this.message});
}

final class LiabilityPaymentEdited extends LiabilityState {}

final class LiabilityPaymentEditError extends LiabilityState {
  final String message;

  LiabilityPaymentEditError({required this.message});
}

final class GotLiability extends LiabilityState {
  final Liability liability;

  GotLiability({required this.liability});
}

final class GetLiabilityError extends LiabilityState {
  final String message;

  GetLiabilityError({required this.message});
}
