import 'package:cashbook/core/types/reponse_types.dart';
import 'package:cashbook/core/usecase/usecase.dart';
import 'package:cashbook/data/models/tag_data.dart';
import 'package:fpdart/src/either.dart';

import '../../../../domain/repositories/tag_repository.dart';

class TagListUseCase implements UseCase<List<TagData>, Failure, void> {
  final TagRepository tagRepository;

  TagListUseCase(this.tagRepository);

  @override
  Future<Either<List<TagData>, Failure>> call(void param) async {
    try {
      return left(await tagRepository.getTags());
    } catch (e) {
      return right(Failure("Error getting tags from database"));
    }
  }
}
