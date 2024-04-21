import 'package:cashbook/data/models/expense.dart';
import 'package:cashbook/data/models/tag_data.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class Liability {
  @Id()
  int id;
  String title;
  double amount;
  double remaining;
  double interest;
  String? description;
  ToOne<TagData> tag = ToOne<TagData>();
  ToMany<Expense> payouts = ToMany<Expense>();
  @Property(type: PropertyType.date)
  DateTime date = DateTime.now();
  @Property(type: PropertyType.date)
  DateTime? endDate;

  Liability(
      {required this.id,
      required this.title,
      required this.amount,
      required this.description,
      required this.date,
      required this.endDate,
      required this.remaining,
      this.interest = 0});

  @override
  String toString() {
    return 'Liability{id: $id, title: $title, worth: $amount,remaining: $remaining,interest: $interest, description: $description, tags: $tag, date: $date, payouts: $payouts}';
  }
}
