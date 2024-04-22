import 'package:cashbook/data/datasource/liability_local_datasource.dart';
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
  void editLiability(Liability liability) {
    return datasource.editLiability(liability);
  }
}
