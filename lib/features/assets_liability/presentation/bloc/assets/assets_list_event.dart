part of 'assets_list_bloc.dart';

@immutable
sealed class AssetsListEvent {}

final class GetAssetsListEvent extends AssetsListEvent {
  final DateTime? startDate;
  final DateTime? endDate;
  final int? count;

  GetAssetsListEvent({
    this.startDate,
    this.endDate,
    this.count,
  });
}
