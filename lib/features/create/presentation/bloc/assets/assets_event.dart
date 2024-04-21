part of 'assets_bloc.dart';

@immutable
sealed class AssetsEvent {}

final class CreateAssetEvent extends AssetsEvent {
  final String title;
  final double worth;
  final String description;
  final DateTime date;
  final String? icon;
  final int color;

  CreateAssetEvent(
      {required this.title,
      required this.worth,
      required this.description,
      required this.date,
      required this.icon,
      this.color = 0xff0000ff});
}
