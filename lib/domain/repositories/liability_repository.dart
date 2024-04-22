import 'package:cashbook/data/models/expense.dart';
import 'package:cashbook/data/models/liability.dart';

abstract interface class LiabilityRepository {
  void createLiability(Liability liability);

  void editLiability(Liability liability);

  List<Liability> getLiabilities({int? count, bool includeFinished = false});

  int payLiability(Liability liability, Expense expense);

  void editLiabilityPayment(int liabilityId, Expense expense, double newAmount);
}
