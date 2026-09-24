/// Base class for all API-related exceptions.
abstract class ApiException implements Exception {
  final String userMessage;
  const ApiException(this.userMessage);

  @override
  String toString() => userMessage;
}

/// No internet connection available.
class NoInternetException extends ApiException {
  const NoInternetException()
    : super('No internet connection. Please check your network.');
}

/// Request timed out.
class ApiTimeoutException extends ApiException {
  const ApiTimeoutException() : super('Request timed out. Please try again.');
}

/// Server returned an error (5xx).
class ServerException extends ApiException {
  final int statusCode;
  ServerException(this.statusCode)
    : super('Server error ($statusCode). Please try again later.');
}

/// Server returned 4xx (client error).
class ClientException extends ApiException {
  final int statusCode;
  ClientException(this.statusCode)
    : super('Request failed ($statusCode). Please try again.');
}

/// Generic unknown error.
class UnknownException extends ApiException {
  const UnknownException() : super('Something went wrong. Please try again.');
}
