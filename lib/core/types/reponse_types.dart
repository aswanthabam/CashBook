class Failure {
  final String message;

  Failure(this.message);

  @override
  String toString() => message;
}

class Success<T> {
  final String message;
  final T payload;

  Success(this.message, this.payload);

  @override
  String toString() => message;
}
