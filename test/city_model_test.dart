import 'package:flutter_test/flutter_test.dart';
import 'package:mcp_ssd_weather/models/city_model.dart';

void main() {
  group('CityModel', () {
    test('fromJson parses Geocoding API response correctly', () {
      final json = {
        'id': 112931,
        'name': 'Tehran',
        'latitude': 35.6944,
        'longitude': 51.4215,
        'country': 'Iran',
        'admin1': 'Tehran Province',
        'country_code': 'IR',
        'population': 8693706,
      };

      final city = CityModel.fromJson(json);

      expect(city.id, 112931);
      expect(city.name, 'Tehran');
      expect(city.latitude, 35.6944);
      expect(city.longitude, 51.4215);
      expect(city.country, 'Iran');
      expect(city.admin1, 'Tehran Province');
      expect(city.countryCode, 'IR');
      expect(city.population, 8693706);
    });

    test('fromJson handles optional null fields gracefully', () {
      final json = {
        'id': 100,
        'name': 'Unknown City',
        'latitude': 10.0,
        'longitude': 20.0,
      };

      final city = CityModel.fromJson(json);

      expect(city.id, 100);
      expect(city.name, 'Unknown City');
      expect(city.country, null);
      expect(city.admin1, null);
      expect(city.countryCode, '');
      expect(city.population, 0);
    });

    test('toJson converts CityModel to Map correctly', () {
      final city = CityModel(
        id: 112931,
        name: 'Tehran',
        latitude: 35.6944,
        longitude: 51.4215,
        country: 'Iran',
        admin1: 'Tehran Province',
        countryCode: 'IR',
      );

      final json = city.toJson();

      expect(json['id'], 112931);
      expect(json['name'], 'Tehran');
      expect(json['latitude'], 35.6944);
      expect(json['longitude'], 51.4215);
      expect(json['country'], 'Iran');
      expect(json['admin1'], 'Tehran Province');
      expect(json['country_code'], 'IR');
    });

    test('locationLabel formats admin1 and country correctly', () {
      final city1 = CityModel(
        id: 1,
        name: 'Tehran',
        latitude: 35.0,
        longitude: 51.0,
        country: 'Iran',
        admin1: 'Tehran Province',
        countryCode: 'IR',
      );
      expect(city1.locationLabel, 'Tehran Province, Iran');

      final city2 = CityModel(
        id: 2,
        name: 'Monaco',
        latitude: 43.7,
        longitude: 7.4,
        country: 'Monaco',
        countryCode: 'MC',
      );
      expect(city2.locationLabel, 'Monaco');
    });

    test('countryFlag converts countryCode to flag emoji', () {
      final cityIR = CityModel(
        id: 1,
        name: 'Tehran',
        latitude: 35.0,
        longitude: 51.0,
        countryCode: 'IR',
      );
      expect(cityIR.countryFlag, '🇮🇷');

      final cityDE = CityModel(
        id: 2,
        name: 'Berlin',
        latitude: 52.5,
        longitude: 13.4,
        countryCode: 'DE',
      );
      expect(cityDE.countryFlag, '🇩🇪');

      final cityInvalid = CityModel(
        id: 3,
        name: 'Empty',
        latitude: 0,
        longitude: 0,
        countryCode: '',
      );
      expect(cityInvalid.countryFlag, '');
    });

    test('displayName returns name when customLabel is null', () {
      final city = CityModel(
        id: 1,
        name: 'Tehran',
        latitude: 0,
        longitude: 0,
        countryCode: 'IR',
      );
      expect(city.displayName, 'Tehran');
      expect(city.hasCustomLabel, false);
    });

    test('displayName returns customLabel when set', () {
      final city = CityModel(
        id: 1,
        name: 'Tehran',
        customLabel: 'Home',
        latitude: 0,
        longitude: 0,
        countryCode: 'IR',
      );
      expect(city.displayName, 'Home');
      expect(city.hasCustomLabel, true);
    });

    test('fromJson parses customLabel', () {
      final json = {
        'id': 1,
        'name': 'Tehran',
        'customLabel': 'Home',
        'latitude': 0.0,
        'longitude': 0.0,
        'country_code': 'IR',
      };
      final city = CityModel.fromJson(json);
      expect(city.customLabel, 'Home');
      expect(city.displayName, 'Home');
    });

    test('toJson includes customLabel', () {
      final city = CityModel(
        id: 1,
        name: 'Tehran',
        customLabel: 'Home',
        latitude: 0,
        longitude: 0,
        countryCode: 'IR',
      );
      final json = city.toJson();
      expect(json['customLabel'], 'Home');
    });

    test('copyWith updates customLabel', () {
      final city = CityModel(
        id: 1,
        name: 'Tehran',
        latitude: 0,
        longitude: 0,
        countryCode: 'IR',
      );
      final updated = city.copyWith(customLabel: 'Home');
      expect(updated.customLabel, 'Home');
      expect(updated.name, 'Tehran');
    });
  });
}
