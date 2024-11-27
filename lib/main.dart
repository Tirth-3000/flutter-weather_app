import 'package:flutter/material.dart';
// import 'package:weather_app/screen/home_screen.dart';
import 'package:weather_app/screen/tabs_screen.dart';

var kColorScheme = ColorScheme.fromSeed(
  seedColor: const Color.fromARGB(255, 228, 151, 62),
);

var kDarkColorScheme = ColorScheme.fromSeed(
  brightness: Brightness.dark,
  seedColor: const Color.fromARGB(173, 5, 29, 35),
);

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TabsScreen(
        latitude: 37.4219983,
        longitude: -122.084,
      ),
      darkTheme: ThemeData.dark().copyWith(
        colorScheme: kDarkColorScheme,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: kDarkColorScheme.primaryContainer,
            foregroundColor: kDarkColorScheme.onPrimaryContainer,
          ),
        ),
        cardTheme: const CardTheme().copyWith(
          shadowColor: Colors.black26,
          color: kDarkColorScheme.secondaryContainer,
          margin: const EdgeInsets.all(8),
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          selectedItemColor: kDarkColorScheme.primary,
          unselectedItemColor: kDarkColorScheme.onSurfaceVariant,
        ),
      ),
      theme: ThemeData().copyWith(
        colorScheme: kColorScheme,
        appBarTheme: const AppBarTheme().copyWith(
          backgroundColor: kColorScheme.onPrimaryContainer,
          foregroundColor: kColorScheme.primaryContainer,
        ),
        cardTheme: const CardTheme().copyWith(
          shadowColor: Colors.black26,
          color: kColorScheme.secondaryContainer,
          margin: const EdgeInsets.all(8),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: kColorScheme.primaryContainer,
            foregroundColor: kColorScheme.onPrimaryContainer,
          ),
        ),
        textTheme: ThemeData().textTheme.copyWith(
              titleLarge: const TextStyle(color: Colors.black, fontSize: 20),
            ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          selectedItemColor: kColorScheme.primary,
          unselectedItemColor: kColorScheme.onSurfaceVariant,
        ),
      ),
      themeMode: ThemeMode.system,
    );
  }
}
