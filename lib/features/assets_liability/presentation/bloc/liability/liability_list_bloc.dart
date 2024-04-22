import 'package:bloc/bloc.dart';
import 'package:cashbook/data/models/expense.dart';
import 'package:cashbook/data/models/liability.dart';
import 'package:cashbook/features/assets_liability/domain/usecases/liability_list_usecase.dart';
import 'package:cashbook/features/assets_liability/domain/usecases/liability_payouts_usecase.dart';
import 'package:meta/meta.dart';

part 'liability_list_event.dart';
part 'liability_list_state.dart';

class LiabilityListBloc extends Bloc<LiabilityListEvent, LiabilityListState> {
  final LiabilityListUseCase _liabilityListUseCase;
  final LiabilityPayoutsUseCase _liabilityPayoutsUseCase;

  LiabilityListBloc(
      {required LiabilityListUseCase liabilityListUseCase,
      required LiabilityPayoutsUseCase liabilityPayoutsUseCase})
      : _liabilityListUseCase = liabilityListUseCase,
        _liabilityPayoutsUseCase = liabilityPayoutsUseCase,
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

    on<GetLiabilityPayoutsEvent>((event, emit) {
      _liabilityPayoutsUseCase.call(event.id).then((value) {
        value.fold((expenses) {
          emit(LiabilityPayoutsLoaded(expenses));
        }, (failure) {
          emit(LiabilityPayoutsError(failure.message));
        });
      });
    });
  }
}
