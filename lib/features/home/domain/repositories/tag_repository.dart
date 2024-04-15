import 'package:cashbook/data/models/tag_data.dart';

abstract interface class TagRepository {
  Future<bool> createTag(
      String title, String? description, int color, String icon);

  Future<List<TagData>> getTags();
}
