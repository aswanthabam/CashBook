import 'package:cashbook/data/models/liability.dart';

abstract interface class LiabilityRepository {
  void createLiability(Liability liability);

  List<Liability> getLiabilities({int? count, bool includeFinished = false});
}
