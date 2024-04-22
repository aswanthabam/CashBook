import 'package:bloc/bloc.dart';
import 'package:cashbook/data/models/liability.dart';
import 'package:cashbook/features/create/domain/usecases/create_liability_usecase.dart';
import 'package:cashbook/features/create/domain/usecases/edit_liability_usecase.dart';
import 'package:meta/meta.dart';

part 'liability_event.dart';
part 'liability_state.dart';

class LiabilityBloc extends Bloc<LiabilityEvent, LiabilityState> {
  CreateLiabilityUseCase _createLiabilityUseCase;
  EditLiabilityUseCase _editLiabilityUseCase;

  LiabilityBloc(
      {required CreateLiabilityUseCase createLiabilityUseCase,
      required EditLiabilityUseCase editLiabilityUseCase})
      : _createLiabilityUseCase = createLiabilityUseCase,
        _editLiabilityUseCase = editLiabilityUseCase,
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

    on<EditLiabilityEvent>((event, emit) {
      _editLiabilityUseCase
          .call(Liability(
              id: event.id,
              title: event.title,
              amount: event.amount,
              description: event.description,
              date: event.date,
              endDate: event.endDate,
              remaining: event.remaining,
              icon: event.icon,
              color: event.color))
          .then((value) {
        value.fold((l) => emit(LiabilityEdited()),
            (r) => LiabilityEditError(message: r.message));
      });
    });
  }
}
