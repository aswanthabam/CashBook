import 'package:bloc/bloc.dart';
import 'package:cashbook/data/models/liability.dart';
import 'package:cashbook/features/assets_liability/domain/usecases/liability_list_usecase.dart';
import 'package:meta/meta.dart';

part 'liability_list_event.dart';
part 'liability_list_state.dart';

class LiabilityListBloc extends Bloc<LiabilityListEvent, LiabilityListState> {
  final LiabilityListUseCase _liabilityListUseCase;

  LiabilityListBloc({required LiabilityListUseCase liabilityListUseCase})
      : _liabilityListUseCase = liabilityListUseCase,
        super(LiabilityListInitial()) {
    on<GetLiabilitiesEvent>((event, emit) {
      _liabilityListUseCase
          .call(LiabilityListParams(
              count: event.count, includeFinished: event.includeFinished))
          .then((value) => value.fold(
              (liabilities) =>
                  emit(LiabilityListLoaded(liabilities: liabilities)),
              (failure) => emit(LiabilityListError(message: failure.message))));
    });
  }
}
