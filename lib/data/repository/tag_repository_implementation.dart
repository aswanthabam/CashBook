import 'package:cashbook/data/datasource/tag_local_database.dart';
import 'package:cashbook/data/models/tag_data.dart';
import 'package:cashbook/domain/repositories/tag_repository.dart';

class TagRepositoryImplementation implements TagRepository {
  TagLocalDatabaseImplementation tagLocalDatabaseImplementation;

  TagRepositoryImplementation(this.tagLocalDatabaseImplementation);

  @override
  Future<bool> createTag(
      String title, String? description, int color, String icon) {
    return tagLocalDatabaseImplementation.createTag(
        title, description, color, icon);
  }

  @override
  Future<List<TagData>> getTags() {
    try {
      return tagLocalDatabaseImplementation.getTags();
    } catch (e) {
      rethrow;
    }
  }
}
