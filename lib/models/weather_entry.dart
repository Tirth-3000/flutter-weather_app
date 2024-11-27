// import 'package:intl/intl.dart';

import 'package:intl/intl.dart';

class WeatherEntry {
  String WeatherIcons;
  double? temp;
  DateTime times;

  WeatherEntry({
    required this.WeatherIcons,
    required this.temp,
    required this.times,
  });

  String get formattedTime {
    final DateFormat formatter = DateFormat('h:mm a');
    return formatter.format(times);
  }

  // factory WeatherEntry.fromJson(Map<String, dynamic> json) {
  // DateTime dateTime = DateTime.parse(json['dt_txt']);
  // String timeonly = DateFormat('HH:mm a').format(dateTime);
  //   return WeatherEntry(
  //     WeatherIcons: json['weather'][0]['icon'],
  //     times: timeonly,
  //     temp: json['main']['temp'],
  //   );
  // }
}
