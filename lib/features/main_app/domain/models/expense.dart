import 'package:cashbook/features/main_app/data/datasource/local/database.dart';
import 'package:cashbook/features/main_app/domain/models/tag_data.dart';
import 'package:cashbook/objectbox.g.dart';

@Entity()
class Expense {
  @Id()
  int id;
  double amount;
  String? description;
  ToMany<TagData> tags = ToMany<TagData>();
  @Property(type: PropertyType.date)
  DateTime date = DateTime.now();

  Expense({required this.id,
      required this.amount, required this.description});

  static Future<ExpenseList> getExpenseList(
      DateTime startDate, DateTime endDate) async {
    AppDatabase database = await AppDatabase.create();
    Query<Expense> query = database.box<Expense>().query(Expense_.date.between(
        startDate.microsecondsSinceEpoch, endDate.microsecondsSinceEpoch));
    List<Expense> res = query.find();
    double totalAmount =
        res.fold(0, (previousValue, element) => previousValue + element.amount);
    return ExpenseList(
        expenses: res,
        startDate: startDate,
        endDate: endDate,
        totalAmount: totalAmount);
  }

  @override
  String toString() {
    return 'Expense{id: $id, amount: $amount, description: $description, tags: $tags}';
  }
}

class ExpenseList {
  final List<Expense> expenses;
  final DateTime startDate;
  final DateTime endDate;
  final double totalAmount;

  const ExpenseList(
      {required this.expenses,
      required this.startDate,
      required this.endDate,
      required this.totalAmount});
}
