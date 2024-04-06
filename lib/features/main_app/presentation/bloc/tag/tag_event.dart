part of 'tag_bloc.dart';

@immutable
sealed class TagEvent {}

final class CreateTagEvent extends TagEvent {
  final String title;
  final String? description;
  final int color;

  CreateTagEvent({required this.title, this.description, required this.color});
}

final class GetTagsEvent extends TagEvent {}
