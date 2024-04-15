import 'package:cashbook/data/models/tag_data.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class Asset {
  @Id()
  int id;
  String title;
  double worth;
  String? description;
  ToOne<TagData> tag = ToOne<TagData>();
  @Property(type: PropertyType.date)
  DateTime date = DateTime.now();

  Asset({
    required this.id,
    required this.title,
    required this.worth,
    required this.description,
    required this.date,
  });

  @override
  String toString() {
    return 'Asset{id: $id, title: $title, worth: $worth, description: $description, tags: $tag, date: $date}';
  }
}
