import 'package:objectbox/objectbox.dart';

@Entity()
class Asset {
  @Id()
  int id;
  String title;
  double worth;
  String? description;
  String? icon;
  @Property(type: PropertyType.date)
  DateTime date = DateTime.now();
  int color;

  Asset(
      {required this.id,
      required this.title,
      required this.worth,
      required this.description,
      required this.date,
      required this.icon,
      required this.color});

  @override
  String toString() {
    return 'Asset{id: $id, title: $title, worth: $worth, description: $description,icon: $icon, date: $date}';
  }
}
