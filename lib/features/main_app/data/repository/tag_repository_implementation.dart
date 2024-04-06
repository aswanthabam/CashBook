import 'package:cashbook/features/main_app/data/datasource/tag_local_database.dart';
import 'package:cashbook/features/main_app/data/models/tag_data.dart';
import 'package:cashbook/features/main_app/domain/repositories/tag_repository.dart';

class TagRepositoryImplementaion implements TagRepository {
  TagLocalDatabaseImplementation tagLocalDatabaseImplementation;

  TagRepositoryImplementaion(this.tagLocalDatabaseImplementation);

  @override
  Future<bool> createTag(String title, String? description, int color) {
    return tagLocalDatabaseImplementation.createTag(title, description, color);
  }

  @override
  Future<List<TagData>> getTags() {
    try {
      return tagLocalDatabaseImplementation.getTags();
    } catch (e) {
      throw e;
    }
  }
}
