class CityModel {
  final int id;
  final String name;
  final String? customLabel; // ← جدید
  final double latitude;
  final double longitude;
  final String? country;
  final String? admin1;
  final String countryCode;
  final int population;

  CityModel({
    required this.id,
    required this.name,
    this.customLabel, // ← جدید
    required this.latitude,
    required this.longitude,
    this.country,
    this.admin1,
    required this.countryCode,
    this.population = 0,
  });

  /// Display name: customLabel if set, otherwise name
  String get displayName => customLabel ?? name;

  /// Whether this city has a custom label
  bool get hasCustomLabel => customLabel != null && customLabel!.isNotEmpty;

  // Factory constructor for Geocoding API response
  factory CityModel.fromJson(Map<String, dynamic> json) {
    return CityModel(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      customLabel: json['customLabel'] as String?, // ← جدید
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      country: json['country'] as String?,
      admin1: json['admin1'] as String?,
      countryCode: (json['country_code'] as String?) ?? '',
      population: (json['population'] as num?)?.toInt() ?? 0,
    );
  }

  // Convert to JSON for local persistence of the selected city
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'customLabel': customLabel, // ← جدید
      'latitude': latitude,
      'longitude': longitude,
      'country': country,
      'admin1': admin1,
      'country_code': countryCode,
      'population': population,
    };
  }

  CityModel copyWith({
    int? id,
    String? name,
    String? customLabel,
    double? latitude,
    double? longitude,
    String? country,
    String? admin1,
    String? countryCode,
    int? population,
  }) {
    return CityModel(
      id: id ?? this.id,
      name: name ?? this.name,
      customLabel: customLabel ?? this.customLabel,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      country: country ?? this.country,
      admin1: admin1 ?? this.admin1,
      countryCode: countryCode ?? this.countryCode,
      population: population ?? this.population,
    );
  }

  // Display location subtitle (e.g. "Tehran Province, Iran")
  String get locationLabel {
    final parts = [
      admin1,
      country,
    ].whereType<String>().where((p) => p.isNotEmpty).toList();
    return parts.join(', ');
  }

  // Convert ISO country code (e.g. "IR", "DE") to emoji flag
  String get countryFlag {
    if (countryCode.length != 2) return '';
    final String upperCode = countryCode.toUpperCase();
    final int firstChar = upperCode.codeUnitAt(0) + 127397;
    final int secondChar = upperCode.codeUnitAt(1) + 127397;
    return String.fromCharCode(firstChar) + String.fromCharCode(secondChar);
  }
}
