import 'package:bloc/bloc.dart';
import 'package:cashbook/data/models/asset.dart';
import 'package:cashbook/data/models/tag_data.dart';
import 'package:cashbook/features/create/domain/usecases/create_asset_usecase.dart';
import 'package:meta/meta.dart';

part 'assets_event.dart';
part 'assets_state.dart';

class AssetsBloc extends Bloc<AssetsEvent, AssetsState> {
  CreateAssetUseCase _assetCreateUseCase;

  AssetsBloc({required assetCreateUseCase})
      : _assetCreateUseCase = assetCreateUseCase,
        super(AssetsInitial()) {
    on<CreateAssetEvent>((event, emit) {
      _assetCreateUseCase(Asset(
              id: 0,
              title: event.title,
              worth: event.worth,
              description: event.description,
              date: event.date))
          .then((value) {
        value.fold(
          (success) {
            emit(AssetCreated());
          },
          (failure) {
            emit(AssetsCreationError(failure.message));
          },
        );
      });
    });
  }
}
