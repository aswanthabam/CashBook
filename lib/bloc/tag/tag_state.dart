part of 'tag_bloc.dart';

@immutable
sealed class TagState {}

final class TagInitial extends TagState {}

final class TagCreated extends TagState {}

final class TagCreateError extends TagState {
  final String message;

  TagCreateError(this.message);
}

final class TagDataLoaded extends TagState {
  final List<TagData> tags;

  TagDataLoaded(this.tags);
}

final class TagDataError extends TagState {
  final String message;

  TagDataError(this.message);
}
