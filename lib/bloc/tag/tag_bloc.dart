import 'package:bloc/bloc.dart';
import 'package:cashbook/data/models/tag_data.dart';
import 'package:cashbook/features/create/domain/usecases/tag_create_usecase.dart';
import 'package:cashbook/features/home/domain/uscases/tag_list_usecase.dart';
import 'package:meta/meta.dart';

part 'tag_event.dart';
part 'tag_state.dart';

class TagBloc extends Bloc<TagEvent, TagState> {
  TagCreateUseCase tagCreateUseCase;
  TagListUseCase tagListUseCase;

  TagBloc({required this.tagCreateUseCase, required this.tagListUseCase})
      : super(TagInitial()) {
    on<GetTagsEvent>((event, emit) {
      tagListUseCase.call(null).then((value) {
        value.fold((tags) {
          emit(TagDataLoaded(tags));
        }, (failure) {
          emit(TagDataError(failure.message));
        });
      });
    });
    on<CreateTagEvent>((event, emit) {
      tagCreateUseCase
          .call(TagCreateParams(
              title: event.title,
              color: event.color,
              description: event.description,
              icon: event.icon))
          .then((value) {
        value.fold((success) {
          emit(TagCreated());
        }, (failure) {
          emit(TagCreateError(failure.message));
        });
      });
    });
  }
}
