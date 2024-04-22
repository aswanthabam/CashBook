import 'package:bloc/bloc.dart';
import 'package:cashbook/data/models/expense.dart';
import 'package:cashbook/data/models/liability.dart';
import 'package:cashbook/features/create/domain/usecases/create_liability_usecase.dart';
import 'package:cashbook/features/create/domain/usecases/edit_liability_payment.dart';
import 'package:cashbook/features/create/domain/usecases/edit_liability_usecase.dart';
import 'package:cashbook/features/create/domain/usecases/pay_liablity_usecase.dart';
import 'package:meta/meta.dart';

part 'liability_event.dart';
part 'liability_state.dart';

class LiabilityBloc extends Bloc<LiabilityEvent, LiabilityState> {
  CreateLiabilityUseCase _createLiabilityUseCase;
  EditLiabilityUseCase _editLiabilityUseCase;
  PayLiabilityUseCase _payLiabilityUseCase;
  EditLiabilityPaymentUseCase _editLiabilityPaymentUseCase;

  LiabilityBloc(
      {required CreateLiabilityUseCase createLiabilityUseCase,
      required EditLiabilityUseCase editLiabilityUseCase,
      required PayLiabilityUseCase payLiabilityUseCase,
      required EditLiabilityPaymentUseCase editLiabilityPaymentUseCase})
      : _createLiabilityUseCase = createLiabilityUseCase,
        _editLiabilityUseCase = editLiabilityUseCase,
        _payLiabilityUseCase = payLiabilityUseCase,
        _editLiabilityPaymentUseCase = editLiabilityPaymentUseCase,
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

    on<PayLiabilityEvent>((event, emit) {
      _payLiabilityUseCase
          .call(PayLiabilityParams(
              liability: event.liability, expense: event.expense))
          .then((value) {
        value.fold((l) => emit(LiabilityPaid()),
            (r) => emit(LiabilityPayError(message: r.message)));
      });
    });

    on<EditLiabilityPaymentEvent>((event, emit) {
      _editLiabilityPaymentUseCase
          .call(EditLiabilityPaymentParams(
              liabilityId: event.liabilityId,
              expense: event.expense,
              newAmount: event.neAmount))
          .then((value) {
        value.fold((l) => emit(LiabilityPaymentEdited()),
            (r) => emit(LiabilityPaymentEditError(message: r.message)));
      });
    });
  }
}
