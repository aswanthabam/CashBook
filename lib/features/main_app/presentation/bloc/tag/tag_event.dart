part of 'tag_bloc.dart';

@immutable
sealed class TagEvent {}

final class CreateTagEvent extends TagEvent {
  final String title;
  final String? description;
  final int color;
  final String icon;

  CreateTagEvent(
      {required this.title,
      this.description,
      required this.color,
      required this.icon});
}

final class GetTagsEvent extends TagEvent {}
