import 'package:bloc/bloc.dart';
import 'package:cashbook/data/models/liability.dart';
import 'package:cashbook/features/create/domain/usecases/create_liability_usecase.dart';
import 'package:meta/meta.dart';

part 'liability_event.dart';
part 'liability_state.dart';

class LiabilityBloc extends Bloc<LiabilityEvent, LiabilityState> {
  CreateLiabilityUseCase _createLiabilityUseCase;

  LiabilityBloc({required CreateLiabilityUseCase createLiabilityUseCase})
      : _createLiabilityUseCase = createLiabilityUseCase,
        super(LiabilityInitial()) {
    on<CreateLiabilityEvent>((event, emit) {
      _createLiabilityUseCase
          .call(Liability(
        id: 0,
        title: event.title,
        amount: event.amount,
        description: event.description,
        date: event.date,
        endDate: event.endDate,
        remaining: event.remaining,
        icon: event.icon,
        color: event.color,
        interest: event.interest,
      ))
          .then((value) {
        value.fold((l) => emit(LiabilityCreated()),
            (r) => emit(LiabilityCreationError(message: r.message)));
      });
    });
  }
}
