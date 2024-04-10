import 'package:cashbook/core/datasource/local/database.dart';
import 'package:cashbook/features/home/data/models/tag_data.dart';
import 'package:cashbook/objectbox.g.dart';

@Entity()
class Expense {
  @Id()
  int id;
  String title;
  double amount;
  String? description;
  ToOne<TagData> tag = ToOne<TagData>();
  @Property(type: PropertyType.date)
  DateTime date = DateTime.now();

  Expense(
      {required this.id,
      required this.title,
      required this.amount,
      required this.description,
    required this.date,
  });

  static Future<ExpenseList> getExpenseList(
      DateTime startDate, DateTime endDate,
      {bool descending = false}) async {
    AppDatabase database = await AppDatabase.create();
    Query<Expense> query = database
        .box<Expense>()
        .query(Expense_.date.between(
            startDate.millisecondsSinceEpoch, endDate.millisecondsSinceEpoch))
        .order(Expense_.date, flags: descending ? 1 : 0)
        .build();
    print("Created query");
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
    return 'Expense{id: $id, title: $title, amount: $amount, description: $description, tags: $tag, date: $date}';
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
