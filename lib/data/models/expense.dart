import 'package:cashbook/data/models/tag_data.dart';
import 'package:objectbox/objectbox.dart';

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
