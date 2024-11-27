abstract class WeatherData {
  String? get weatherIcon;
  String? get areaName;
  String? get weatherDiscription;
  String? get country;
  double? get temperature;
  double? get wind;
  double? get humidity;
  DateTime? get sunrise;
  DateTime? get sunset;
  double? get timezoneOffset;
  List<DateTime> get date;

  String getFormattedData();
}
