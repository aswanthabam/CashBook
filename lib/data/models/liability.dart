import 'package:cashbook/data/models/expense.dart';
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
  String? icon;
  int color;
  ToMany<Expense> payouts = ToMany<Expense>();
  @Property(type: PropertyType.date)
  DateTime date = DateTime.now();
  @Property(type: PropertyType.date)
  DateTime? endDate;
  @Property(type: PropertyType.date)
  DateTime updatedOn;

  Liability(
      {required this.id,
      required this.title,
      required this.amount,
      required this.description,
      required this.date,
      required this.endDate,
      required this.remaining,
      required this.icon,
      required this.color,
      this.interest = 0,
      required this.updatedOn});

  @override
  String toString() {
    return 'Liability{id: $id, title: $title, worth: $amount,remaining: $remaining,interest: $interest, description: $description, icon: $icon,color: $color, date: $date, payouts: $payouts}';
  }
}
