import 'package:cashbook/data/models/expense.dart';
import 'package:cashbook/data/models/liability.dart';

abstract interface class LiabilityRepository {
  void createLiability(Liability liability);

  void editLiability({
    required int id,
    String? title,
    double? amount,
    String? description,
    DateTime? date,
    DateTime? endDate,
    double? remaining,
    String? icon,
    int? color,
    double? interest,
  });

  List<Liability> getLiabilities({int? count, bool includeFinished = false});

  int payLiability(Liability liability, Expense expense);

  void editLiabilityPayment(
      Liability liability, Expense expense, double newAmount);

  Liability getLiability(int id);

  List<Expense> getLiabilityPayments(int id);
}
