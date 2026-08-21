class ApiError {
  String? message;
  String? statuscode;
  ApiError({required this.message, this.statuscode});

  @override
  String toString() {
    return 'ApiError{message: $message, statuscode: $statuscode}';
  }
}
