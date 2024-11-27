import 'package:flutter/material.dart';
// import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/models/weather_data.dart';

class DetailWidget extends StatelessWidget {
  DetailWidget({super.key, required this.weatherData});
  final WeatherData weatherData;
  final now = DateTime.now();

  String formatTime(DateTime? dateTime, int timezoneOffset) {
    if (dateTime == null) return '';
    // Adjust the time for the timezone offset
    DateTime localTime = dateTime.add(Duration(seconds: timezoneOffset));
    return DateFormat('h:mm a').format(localTime);
  }

  bool afterSunSet() {
    DateTime localTime =
        now.add(Duration(seconds: (weatherData.timezoneOffset ?? 0).toInt()));
    DateTime LocalSunset = weatherData.sunset!
        .add(Duration(seconds: (weatherData.timezoneOffset ?? 0).toInt()));
    return localTime.isAfter(LocalSunset);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              child: Row(
                children: [
                  const Icon(Icons.air_rounded),
                  Text('${weatherData.wind} m/s'),
                ],
              ),
            ),
            SizedBox(
              child: Row(
                children: [
                  const Icon(Icons.water_drop_outlined),
                  Text('${weatherData.humidity}%'),
                ],
              ),
            ),
            SizedBox(
              child: Row(
                children: [
                  const Icon(Icons.wb_sunny_outlined),
                  Text(
                    formatTime(weatherData.sunrise,
                        (weatherData.timezoneOffset ?? 0).toInt()),
                  )
                ],
              ),
            ),
            SizedBox(
              child: Row(
                children: [
                  const Icon(Icons.nightlight_outlined),
                  Text(
                    formatTime(weatherData.sunset,
                        (weatherData.timezoneOffset ?? 0).toInt()),
                  ),
                ],
              ),
            )
          ],
        ),
      ],
    );
  }
}
