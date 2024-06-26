part of 'liability_list_bloc.dart';

@immutable
sealed class LiabilityListEvent {}

final class GetLiabilitiesEvent extends LiabilityListEvent {
  final int? count;
  final bool includeFinished;

  GetLiabilitiesEvent({this.count, this.includeFinished = false});
}

final class GetLiabilityPayoutsEvent extends LiabilityListEvent {
  final int id;

  GetLiabilityPayoutsEvent({required this.id});
}