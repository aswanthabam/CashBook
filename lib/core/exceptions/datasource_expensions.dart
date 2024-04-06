class LocalDatabaseException extends Error {
  final String message;

  LocalDatabaseException(this.message);

  @override
  String toString() {
    return message;
  }
}
