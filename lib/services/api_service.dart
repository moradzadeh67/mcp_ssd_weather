import 'dart:convert';
import 'dart:async';

import 'package:http/http.dart' as http;

import '../models/city_model.dart';
import '../models/weather_model.dart';
import 'api_exceptions.dart';

class ApiService {
  // Base URL for Open-Meteo Free API
  static const String _baseUrl = 'https://api.open-meteo.com/v1/forecast';

  // Base URL for Open-Meteo Geocoding API (city search)
  static const String _geoBaseUrl =
      'https://geocoding-api.open-meteo.com/v1/search';

  // Default coordinates for Tehran, Iran
  static const double _defaultLat = 35.6892;
  static const double _defaultLon = 51.3890;

  // Fetch Weather Data from API
  Future<WeatherModel> fetchWeather({
    double latitude = _defaultLat,
    double longitude = _defaultLon,
    String cityName = 'Tehran',
  }) async {
    final url = Uri.parse(
      '$_baseUrl?latitude=$latitude&longitude=$longitude'
      '&current=temperature_2m,relative_humidity_2m,weather_code,wind_speed_10m,surface_pressure'
      '&daily=weather_code,temperature_2m_max,temperature_2m_min'
      '&hourly=temperature_2m,weather_code'
      '&timezone=auto',
    );

    try {
      final response = await http.get(url).timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return WeatherModel.fromApiJson(data, cityName);
      } else if (response.statusCode >= 500) {
        throw ServerException(response.statusCode);
      } else if (response.statusCode >= 400) {
        throw ClientException(response.statusCode);
      } else {
        throw const UnknownException();
      }
    } on TimeoutException {
      throw const ApiTimeoutException();
    } on http.ClientException {
      throw const NoInternetException();
    } on ApiException {
      rethrow;
    } catch (e) {
      throw const UnknownException();
    }
  }

  // Search for cities by name using Open-Meteo Geocoding API
  Future<List<CityModel>> searchCities(String query) async {
    final url = Uri.parse(
      '$_geoBaseUrl?name=${Uri.encodeQueryComponent(query)}&count=25&format=json',
    );

    try {
      final response = await http.get(url).timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final results = (data['results'] as List<dynamic>?) ?? [];
        return results
            .map((e) => CityModel.fromJson(e as Map<String, dynamic>))
            .toList();
      } else if (response.statusCode >= 500) {
        throw ServerException(response.statusCode);
      } else if (response.statusCode >= 400) {
        throw ClientException(response.statusCode);
      } else {
        throw const UnknownException();
      }
    } on TimeoutException {
      throw const ApiTimeoutException();
    } on http.ClientException {
      throw const NoInternetException();
    } on ApiException {
      rethrow;
    } catch (e) {
      throw const UnknownException();
    }
  }
}
