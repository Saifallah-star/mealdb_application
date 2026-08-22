class ApiError {
  String? message;

  ApiError({required this.message});

  @override
  String toString() {
    return 'ApiError{message: $message}';
  }
}
