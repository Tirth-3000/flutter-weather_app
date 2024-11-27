import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:weather_app/models/weather_entry.dart';
import 'package:weather_app/widget/single_card.dart';

class HourlyWidget extends StatefulWidget {
  final DateTime date;
  final List<Map<String, dynamic>> hourlyData;

  const HourlyWidget({
    super.key,
    required this.latitude,
    required this.longitude,
    required this.date,
    required this.hourlyData,
  });

  final double latitude;
  final double longitude;

  @override
  State<HourlyWidget> createState() => _HourlyWidgetState();
}

class _HourlyWidgetState extends State<HourlyWidget> {
  bool shimmerState = false;
  List<WeatherEntry>? weatherEntry;
  List<WeatherEntry>? filteredEntries;
  static const String _apiKey = "7949c7cba611abf28e4dc93744017691";

  @override
  void initState() {
    shimmerState = true;
    fetchWeatherData(widget.latitude, widget.longitude);
    super.initState();
  }

  void fetchWeatherData(double latitude, double longitude) async {
    try {
      final response = await http.get(Uri.parse(
          'https://api.openweathermap.org/data/2.5/forecast?lat=$latitude&lon=$longitude&appid=$_apiKey&units=metric'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Parse the list of weather entries
        List<WeatherEntry> weatherEntries = (data['list'] as List)
            .map((entry) {
              try {
                final dateTime = DateTime.parse(entry['dt_txt']);
                final tempValue = entry['main']['temp'];
                final temp =
                    tempValue is int ? tempValue.toDouble() : tempValue;
                return WeatherEntry(
                  temp: temp,
                  WeatherIcons: entry['weather'][0]['icon'],
                  times: dateTime,
                );
              } catch (e) {
                print('Error parsing entry date: $e');
                return null; // Or handle the error appropriately
              }
            })
            .where((entry) => entry != null)
            .map((entry) => entry!)
            .toList();

        // Filter entries by the date
        final filtered = weatherEntries.where((entry) {
          final entryDate = entry.times.toLocal();
          return entryDate.year == widget.date.year &&
              entryDate.month == widget.date.month &&
              entryDate.day == widget.date.day;
        }).toList();

        setState(() {
          weatherEntry = weatherEntries;
          filteredEntries = filtered;
          shimmerState = false;
        });
      } else {
        print('Failed to fetch weather data: ${response.statusCode}');
      }
    } catch (error) {
      print('Error occurred: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('EEEE, MMM d').format(widget.date);
    return shimmerState
        ? Shimmer.fromColors(
            baseColor: Colors.white,
            highlightColor: Colors.transparent,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 24,
                      height: 27,
                      child: Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 6,
                    ),
                    SizedBox(
                      width: 200,
                      height: 27,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 4,
                ),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 170,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: 6,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                width: 100,
                                height: 200,
                                child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 8,
                ),
              ],
            ),
          )
        : Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.watch_later_outlined,
                    size: 25,
                  ),
                  const SizedBox(
                    width: 6,
                  ),
                  Text(
                    formattedDate,
                    style: GoogleFonts.heebo(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(
                height: 4,
              ),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 170,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: filteredEntries!.length,
                        itemBuilder: (context, index) {
                          final entry = filteredEntries![index];
                          return SingleCard(
                            title: entry.formattedTime,
                            description: '${entry.temp!.toString()} °C',
                            iconUrl:
                                'http://openweathermap.org/img/wn/${entry.WeatherIcons}.png',
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 8,
              ),
            ],
          );
  }
}
