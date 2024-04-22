import 'package:cashbook/data/datasource/liability_local_datasource.dart';
import 'package:cashbook/data/models/expense.dart';
import 'package:cashbook/data/models/liability.dart';
import 'package:cashbook/domain/repositories/liability_repository.dart';

class LiabilityRepositoryImplementation implements LiabilityRepository {
  LiabilityLocalDataSource datasource;

  LiabilityRepositoryImplementation({required this.datasource});

  @override
  void createLiability(Liability liability) {
    datasource.addLiability(liability);
  }

  @override
  List<Liability> getLiabilities({int? count, bool includeFinished = false}) {
    return datasource.getLiabilities(
        count: count, includeFinished: includeFinished);
  }

  @override
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
  }) {
    return datasource.editLiability(
        id: id,
        title: title,
        amount: amount,
        description: description,
        date: date,
        endDate: endDate,
        remaining: remaining,
        icon: icon,
        color: color,
        interest: interest);
  }

  @override
  int payLiability(Liability liability, Expense expense) {
    return datasource.payLiability(liability, expense);
  }

  @override
  void editLiabilityPayment(Liability liability, Expense expense,
      double newAmount) {
    return datasource.editLiabilityPayment(liability, expense, newAmount);
  }

  @override
  Liability getLiability(int id) {
    return datasource.getLiability(id);
  }

  @override
  List<Expense> getLiabilityPayments(int id) {
    return datasource.getLiabilityPayments(id);
  }
}
