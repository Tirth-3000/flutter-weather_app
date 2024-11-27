import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:weather_app/models/weather_data.dart';

class WeatherWidget extends StatelessWidget {
  const WeatherWidget({super.key, required this.weatherData});
  final WeatherData weatherData;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image(
          height: double.infinity,
          width: double.infinity,
          fit: BoxFit.cover,
          image: NetworkImage(
              'http://openweathermap.org/img/wn/${weatherData.weatherIcon}@2x.png'),
        ),
        // Container(
        //   height: 1200,
        //   width: 1200,
        //   color: Colors.red,
        // ),

        Positioned.fill(
          child: BackdropFilter(
            // blendMode: BlendMode.overlay,
            filter: ImageFilter.blur(
              sigmaX: 70,
              sigmaY: 70,
              // tileMode: TileMode.decal,
            ),
            child: const SizedBox.shrink(),
            // child: Container(
            //   decoration: BoxDecoration(
            //     color: Colors.black.withOpacity(0),
            //   ),
            // ),
          ),
        ),
        Container(
          alignment: Alignment.center,
          height: MediaQuery.of(context).size.height * 0.5,
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Text(
                    weatherData.getFormattedData(),
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Container(
                height: 150,
                width: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(
                        'http://openweathermap.org/img/wn/${weatherData.weatherIcon}@4x.png'),
                  ),
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: '${weatherData.temperature!.toInt()}\u00B0 ',
                        style: const TextStyle(
                          fontSize: 50,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const TextSpan(
                        text: 'C\n',
                        style: TextStyle(
                          fontSize: 35,
                          textBaseline: TextBaseline.alphabetic,
                        ),
                      ),
                      TextSpan(
                        text: '${weatherData.weatherDiscription}',
                        style: const TextStyle(
                          fontSize: 15,
                          textBaseline: TextBaseline.alphabetic,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 4,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
