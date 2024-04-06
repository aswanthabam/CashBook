import 'package:fpdart/fpdart.dart';

abstract interface class UseCase<T, V, P> {
  Future<Either<T, V>> call(P param);
}
