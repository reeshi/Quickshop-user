class ErrorHandler extends Error {
  final String message;
  ErrorHandler(this.message);

  @override
  String toString() {
    return message;
  }
}
