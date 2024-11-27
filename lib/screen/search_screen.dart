import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:weather_app/screen/home_screen.dart';
import 'package:weather_app/screen/tabs_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() {
    return _SearchScreenState();
  }
}

class _SearchScreenState extends State<SearchScreen> {
  late Future<List<Map<String, dynamic>>> _catalogData;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _catalogData = loadJsonFromAssets();
  }

  Future<List<Map<String, dynamic>>> loadJsonFromAssets() async {
    String jsonString = await rootBundle.loadString('assets/city_list.json');
    List<dynamic> jsonResponse = json.decode(jsonString);
    return jsonResponse.cast<Map<String, dynamic>>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text(
          'Search',
          style: TextStyle(
            fontSize: 17,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'City',
                      border: OutlineInputBorder(
                        gapPadding: 3,
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  iconSize: 34,
                  padding: const EdgeInsets.all(8),
                  onPressed: () {
                    FocusScope.of(context).unfocus();
                    _catalogData.then((cities) {
                      final matchingCity = cities
                          .where((city) => city['name']
                              .toLowerCase()
                              .contains(_searchQuery.toLowerCase()))
                          .toList();

                      if (matchingCity.isNotEmpty) {
                        final city = matchingCity.first;
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => TabsScreen(
                                latitude: city['coord']['lat'],
                                longitude: city['coord']['lon']),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('No such city is there'),
                          ),
                        );
                      }
                    });
                  },
                  icon: const Icon(Icons.search),
                )
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: _catalogData,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No cities found.'));
                  }

                  List<Map<String, dynamic>> cities = snapshot.data!
                      .where(
                        (city) => city['name'].toLowerCase().contains(
                              _searchQuery.toLowerCase(),
                            ),
                      )
                      .toList();

                  return ListView.builder(
                    itemCount: cities.length,
                    itemBuilder: (context, index) {
                      final city = cities[index];
                      return ListTile(
                        title: Text(
                          '${city['name']} ,${city['country']}',
                          style: const TextStyle(fontSize: 18),
                        ),
                        onTap: () {
                          FocusScope.of(context).unfocus();
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => TabsScreen(
                                latitude: city['coord']['lat'],
                                longitude: city['coord']['lon'],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
