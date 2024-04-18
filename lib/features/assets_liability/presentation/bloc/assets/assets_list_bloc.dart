import 'package:bloc/bloc.dart';
import 'package:cashbook/data/models/asset.dart';
import 'package:cashbook/features/assets_liability/domain/usecases/assets_list_usecase.dart';
import 'package:meta/meta.dart';

part 'assets_list_event.dart';
part 'assets_list_state.dart';

class AssetsListBloc extends Bloc<AssetsListEvent, AssetsListState> {
  final AssetsListUseCase _assetsListUseCase;

  AssetsListBloc({required AssetsListUseCase assetsListUseCase})
      : _assetsListUseCase = assetsListUseCase,
        super(AssetsListInitial()) {
    on<GetAssetsListEvent>((event, emit) {
      _assetsListUseCase(AssetsListParams(
        startDate: event.startDate,
        endDate: event.endDate,
        count: event.count,
      )).then((value) {
        value.fold((assets) {
          emit(AssetsListLoaded(assets));
        }, (failure) {
          emit(AssetsListError(failure.message));
        });
      });
    });
  }
}
