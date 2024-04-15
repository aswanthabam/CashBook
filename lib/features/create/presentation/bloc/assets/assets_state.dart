part of 'assets_bloc.dart';

@immutable
sealed class AssetsState {}

final class AssetsInitial extends AssetsState {}

final class AssetCreated extends AssetsState {}

final class AssetsCreationError extends AssetsState {
  final String message;

  AssetsCreationError(this.message);

  @override
  String toString() {
    return message;
  }
}
