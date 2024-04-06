import 'package:cashbook/core/datasource/local/database.dart';
import 'package:cashbook/core/exceptions/datasource_expensions.dart';
import 'package:cashbook/features/main_app/data/models/tag_data.dart';

abstract interface class TagLocalDatabase {
  Future<bool> createTag(String title, String? description, int color);

  Future<List<TagData>> getTags();
}

class TagLocalDatabaseImplementation implements TagLocalDatabase {
  final AppDatabase database;

  TagLocalDatabaseImplementation(this.database);

  @override
  Future<bool> createTag(String title, String? description, int color) async {
    try {
      TagData entity = TagData(
        id: 0,
        title: title,
        description: description,
        color: color,
      );
      database.insert(entity);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<List<TagData>> getTags() async {
    try {
      return await database.getAll<TagData>();
    } catch (e) {
      throw LocalDatabaseException("Error getting tags from database");
    }
  }
}
