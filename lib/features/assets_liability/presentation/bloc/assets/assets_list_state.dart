part of 'assets_list_bloc.dart';

@immutable
sealed class AssetsListState {}

final class AssetsListInitial extends AssetsListState {}

final class AssetsListLoaded extends AssetsListState {
  final List<Asset> assets;

  AssetsListLoaded(this.assets);
}

final class AssetsListError extends AssetsListState {
  final String message;

  AssetsListError(this.message);
}
