import 'package:cashbook/features/home/data/models/tag_data.dart';

abstract interface class TagRepository {
  Future<bool> createTag(
      String title, String? description, int color, String icon);

  Future<List<TagData>> getTags();
}
