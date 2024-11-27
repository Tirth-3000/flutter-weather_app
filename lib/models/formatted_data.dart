import 'weather_data.dart';

class FormattedData implements WeatherData {
  @override
  final String? areaName;

  @override
  final String? weatherDiscription;

  @override
  final double? temperature;

  @override
  final String? country;

  @override
  final double? wind;

  @override
  final double? humidity;

  @override
  final String? weatherIcon;

  @override
  final DateTime? sunrise;

  @override
  final DateTime? sunset;

  @override
  final double? timezoneOffset;

  @override
  final List<DateTime> date;

  FormattedData({
    this.areaName,
    this.temperature,
    this.weatherDiscription,
    this.country,
    this.weatherIcon,
    this.wind,
    this.humidity,
    this.sunrise,
    this.sunset,
    this.timezoneOffset,
    required this.date,
  });

  @override
  String getFormattedData() {
    return areaName != null ? '$areaName , $country' : "No data available";
  }
}
