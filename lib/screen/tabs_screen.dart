import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:weather_app/screen/home_screen.dart';
import 'package:weather_app/screen/search_screen.dart';

class TabsScreen extends StatefulWidget {
  TabsScreen({super.key, required this.latitude, required this.longitude});

  double latitude;
  double longitude;

  @override
  State<TabsScreen> createState() {
    return _TabScreenState();
  }
}

class _TabScreenState extends State<TabsScreen> {
  int _selectedIndex = 0;
  @override
  void initState() {
    _getLocation();
    super.initState();
  }

  void _getLocation() async {
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    locationData = await location.getLocation();
    final lat = locationData.latitude;
    final long = locationData.longitude;

    setState(
      () {
        widget.latitude = lat!;
        widget.longitude = long!;
      },
    );
  }

  late final List<Widget> _screens = <Widget>[
    HomeScreen(
      latitude: widget.latitude,
      longitude: widget.longitude,
    ),
    const SearchScreen(),
    // NotificationScreen(),
    // MapScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(15)),
            boxShadow: [
              BoxShadow(
                spreadRadius: 1,
                blurRadius: 15,
                color: Color.fromARGB(31, 171, 167, 167),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(15)),
            child: BottomNavigationBar(
              currentIndex: _selectedIndex,
              onTap: _onItemTapped,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home_outlined),
                  label: 'home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.search),
                  label: 'Search',
                ),
                BottomNavigationBarItem(
                    icon: Icon(Icons.notifications_none_outlined),
                    label: 'notification'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.map_outlined), label: 'Map'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
