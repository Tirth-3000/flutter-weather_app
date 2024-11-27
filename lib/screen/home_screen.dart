import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:weather_app/models/formatted_data.dart';
// import 'package:weather_app/screen/search_screen.dart';
import 'package:weather_app/widget/detail_widget.dart';
import 'package:weather_app/widget/hourly_widget.dart';
// import 'package:weather_app/models/weather_data.dart';
import 'package:weather_app/widget/weather_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen(
      {super.key, required this.latitude, required this.longitude});

  final double latitude;
  final double longitude;

  @override
  State<HomeScreen> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  FormattedData? weatherData;
  static const String _apiKey = "7949c7cba611abf28e4dc93744017691";

  // final WeatherFactory _weatherFactory =
  //     WeatherFactory('7949c7cba611abf28e4dc93744017691');

  @override
  void initState() {
    super.initState();
    fetchWeatherData(widget.latitude, widget.longitude);
  }

  // void fetchWeatherData(double latitude, double longitude) async {
  //   // const String apikey = "7949c7cba611abf28e4dc93744017691";

  //   //   final url = Uri.parse(
  // 'https://api.openweathermap.org/data/2.5/forecast?q=London&appid=7949c7cba611abf28e4dc93744017691&units=metric');

  //   // Weather weather = await _weatherFactory.currentWeatherByCityName('London');

  //   try {
  //     http.Response response = await http.get(Uri.parse(
  //         'https://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&appid=$_apiKey&units=metric'));
  //     // final response = await http.get(url);
  //     print("object => ${response.body}");
  //     if (response.statusCode == 200) {
  //       final data = jsonDecode(response.body);
  //       print(data);
  //       setState(() {
  //         weatherData = FormattedData(
  //           areaName: data['name'],
  //           weatherDiscription: data['weather'][0]['description'],
  //           temperature: data['main']['temp'],
  //           country: data['sys']['country'],
  //           weatherIcon: data['weather'][0]['icon'],
  //           wind: data['wind']['speed'],
  //           humidity: double.tryParse(data['main']['humidity'].toString()),
  //           sunrise: DateTime.fromMillisecondsSinceEpoch(
  //               data['sys']['sunrise'] * 1000,
  //               isUtc: true),
  //           sunset: DateTime.fromMillisecondsSinceEpoch(
  //               data['sys']['sunset'] * 1000,
  //               isUtc: true),
  //           timezoneOffset: double.tryParse(data['timezone'].toString()),
  //         );
  //       });
  //     } else {
  //       print('Failed to fetch weather data: ${response.statusCode}');
  //     }
  //   } catch (error) {
  //     print('Error occurred: $error');
  //   }
  // }

  void fetchWeatherData(double latitude, double longitude) async {
    try {
      http.Response response = await http.get(Uri.parse(
          'https://api.openweathermap.org/data/2.5/forecast?lat=${widget.latitude}&lon=${widget.longitude}&appid=$_apiKey&units=metric'));
      // final response = await http.get(url);
      print("object => ${response.body}");
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        List<DateTime> dateList = (data['list'] as List).map((item) {
          final dateTime = DateTime.parse(item['dt_txt']);

          return DateTime(dateTime.year, dateTime.month, dateTime.day);
        }).toList();

        final Map<DateTime, List<Map<String, dynamic>>> hourlyData = {};
        for (var item in data['list']) {
          final dateTime = DateTime.parse(item['dt_txt']);
          final date = DateTime(dateTime.year, dateTime.month, dateTime.day);
          if (!hourlyData.containsKey(date)) {
            hourlyData[date] = [];
          }
          hourlyData[date]!.add(item);
        }

        print(dateList);
        setState(() {
          weatherData = FormattedData(
            areaName: data['city']['name'],
            weatherDiscription: data['list'][0]['weather'][0]['description'],
            temperature: data['list'][0]['main']['temp'] ?? 0.0,
            country: data['city']['country'],
            weatherIcon: data['list'][0]['weather'][0]['icon'],
            wind: double.tryParse(data['list'][0]['wind']['speed'].toString()),
            humidity:
                double.tryParse(data['list'][0]['main']['humidity'].toString()),
            sunrise: DateTime.fromMillisecondsSinceEpoch(
                data['city']['sunrise'] * 1000,
                isUtc: true),
            sunset: DateTime.fromMillisecondsSinceEpoch(
                data['city']['sunset'] * 1000,
                isUtc: true),
            timezoneOffset:
                double.tryParse(data['city']['timezone'].toString()),
            date: dateList,
          );
          _hourlyDataByDay = hourlyData;
        });
      } else {
        print('Failed to fetch weather data: ${response.statusCode}');
      }
    } catch (error) {
      print('Error occurred: $error');
    }
  }

  Map<DateTime, List<Map<String, dynamic>>> _hourlyDataByDay = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // scrolledUnderElevation: 0,
        forceMaterialTransparency: false,
        backgroundColor: const Color.fromARGB(221, 21, 21, 21),
        surfaceTintColor: Colors.transparent,
        title: const SafeArea(
          child: Text('Weather App'),
        ),
        actions: [
          SafeArea(
            child: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.calendar_month_outlined),
            ),
          ),
        ],
      ),
      drawer: Drawer(
        shape: const RoundedRectangleBorder(),
        child: ListView(
          children: const [
            DrawerHeader(
              decoration:
                  BoxDecoration(color: Color.fromARGB(146, 55, 181, 239)),
              child: Text(
                'Location',
                style: TextStyle(color: Colors.white, fontSize: 26),
              ),
            ),
          ],
        ),
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              height: 350,
              width: double.infinity,
              alignment: Alignment.center,
              child: weatherData == null
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : WeatherWidget(weatherData: weatherData!),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              width: double.infinity,
              alignment: Alignment.center,
              child: weatherData == null
                  ? const Text("")
                  : DetailWidget(weatherData: weatherData!),
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              width: double.infinity,
              height: 275,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    children: _hourlyDataByDay.entries.map((entry) {
                      final date = entry.key;
                      final hourlyItems = entry.value;
                      return HourlyWidget(
                        date: date,
                        hourlyData: hourlyItems,
                        latitude: widget.latitude,
                        longitude: widget.longitude,
                      );
                    }).toList(),

                    // HourlyWidget(latitude: latitude, longitude: longitude),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
