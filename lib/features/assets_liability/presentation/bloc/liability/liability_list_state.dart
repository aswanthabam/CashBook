part of 'liability_list_bloc.dart';

@immutable
sealed class LiabilityListState {}

final class LiabilityListInitial extends LiabilityListState {}

final class LiabilityListLoaded extends LiabilityListState {
  final List<Liability> liabilities;

  LiabilityListLoaded({required this.liabilities});
}

final class LiabilityListError extends LiabilityListState {
  final String message;

  LiabilityListError({required this.message});
}
