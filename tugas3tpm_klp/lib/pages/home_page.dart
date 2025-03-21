import 'package:flutter/material.dart';
import 'features/stopwatch_page.dart';
import 'features/number_type_page.dart';
import 'features/tracking_lbs_page.dart';
import 'features/time_conversion_page.dart';
import 'features/favorite_sites_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  // final List<Widget> _pages = [
  //   StopwatchPage(),
  //   NumberTypePage(),
  //   TrackingLBSPage(),
  //   TimeConversionPage(),
  //   FavoriteSitesPage(),
  // ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    Navigator.pushReplacementNamed(context, '/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _logout,
          )
        ],
      ),
      // body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.timer), label: 'Stopwatch'),
          BottomNavigationBarItem(icon: Icon(Icons.numbers), label: 'Numbers'),
          BottomNavigationBarItem(icon: Icon(Icons.location_on), label: 'Tracking'),
          BottomNavigationBarItem(icon: Icon(Icons.access_time), label: 'Time Convert'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favorites'),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}