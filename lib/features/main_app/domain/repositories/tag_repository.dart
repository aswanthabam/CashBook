import 'package:cashbook/features/main_app/data/models/tag_data.dart';

abstract interface class TagRepository {
  Future<bool> createTag(String title, String? description, int color);

  Future<List<TagData>> getTags();
}
