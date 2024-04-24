import 'package:bloc/bloc.dart';
import 'package:cashbook/data/models/expense.dart';
import 'package:meta/meta.dart';

part 'expense_analytics_event.dart';
part 'expense_analytics_state.dart';

class ExpenseAnalyticsBloc
    extends Bloc<ExpenseAnalyticsEvent, ExpenseAnalyticsState> {
  ExpenseAnalyticsBloc() : super(ExpenseAnalyticsInitial()) {
    on<ExpenseAnalyticsEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
