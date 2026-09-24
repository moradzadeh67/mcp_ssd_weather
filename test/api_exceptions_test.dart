import 'package:flutter_test/flutter_test.dart';
import 'package:mcp_ssd_weather/services/api_exceptions.dart';

void main() {
  group('ApiException', () {
    test('NoInternetException has correct message', () {
      const e = NoInternetException();
      expect(
        e.userMessage,
        'No internet connection. Please check your network.',
      );
    });

    test('ApiTimeoutException has correct message', () {
      const e = ApiTimeoutException();
      expect(e.userMessage, 'Request timed out. Please try again.');
    });

    test('ServerException includes status code', () {
      final e = ServerException(500);
      expect(e.userMessage, contains('500'));
    });

    test('ClientException includes status code', () {
      final e = ClientException(404);
      expect(e.userMessage, contains('404'));
    });

    test('UnknownException has correct message', () {
      const e = UnknownException();
      expect(e.userMessage, 'Something went wrong. Please try again.');
    });
  });
}
