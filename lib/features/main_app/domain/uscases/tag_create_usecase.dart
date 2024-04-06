import 'package:cashbook/core/types/reponse_types.dart';
import 'package:cashbook/core/usecase/usecase.dart';
import 'package:cashbook/features/main_app/domain/repositories/tag_repository.dart';
import 'package:fpdart/src/either.dart';

class TagCreateUseCase implements UseCase<bool, Failure, TagCreateParams> {
  TagRepository repository;

  TagCreateUseCase(this.repository);

  @override
  Future<Either<bool, Failure>> call(TagCreateParams param) async {
    if (await repository.createTag(param.title, param.description, param.color))
      return left(true);
    else
      return right(Failure("Error creating tag"));
  }
}

class TagCreateParams {
  final String title;
  final String? description;
  final int color;

  TagCreateParams({required this.title, required this.color, this.description});
}
