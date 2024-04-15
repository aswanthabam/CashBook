part of 'assets_bloc.dart';

@immutable
sealed class AssetsEvent {}

final class CreateAssetEvent extends AssetsEvent {
  final String title;
  final double worth;
  final String description;
  final DateTime date;
  final TagData? tag;

  CreateAssetEvent(
      {required this.title,
      required this.worth,
      required this.description,
      required this.date,
      required this.tag});
}
