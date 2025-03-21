import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'features/stopwatch_page.dart';
import 'features/number_type_page.dart';
import 'features/tracking_lbs_page.dart';
import 'features/time_converter_page.dart';
import 'features/favorite_sites_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _greetingMessage = "";
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? nickname = prefs.getString('nickname');
    String? username = prefs.getString('username');

    setState(() {
      String displayName = (nickname != null && nickname.isNotEmpty) ? nickname : (username ?? "User");
      _greetingMessage = "Selamat datang, $displayName!";
    });
  }

  Future<void> _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.pushReplacementNamed(context, '/');
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        // Tetap di halaman utama
        break;
      case 1:
        // Navigasi ke daftar anggota (jika ada)
        break;
      case 2:
        // Tampilkan dialog bantuan
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Bantuan"),
            content: Text("Ini adalah aplikasi multi-fungsi dengan berbagai fitur yang bisa Anda gunakan."),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("Tutup"),
              )
            ],
          ),
        );
        break;
    }
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
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              _greetingMessage,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                ListTile(
                  leading: Icon(Icons.timer),
                  title: Text("Stopwatch"),
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => StopwatchPage())),
                ),
                ListTile(
                  leading: Icon(Icons.numbers),
                  title: Text("Jenis Bilangan"),
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => NumberTypePage())),
                ),
                ListTile(
                  leading: Icon(Icons.location_on),
                  title: Text("Tracking LBS"),
                  // onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => TrackingLBSPage())),
                ),
                ListTile(
                  leading: Icon(Icons.access_time),
                  title: Text("Konversi Waktu"),
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => TimeConverterPage())),
                ),
                ListTile(
                  leading: Icon(Icons.favorite),
                  title: Text("Situs Rekomendasi"),
                  // onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => FavoriteSitesPage())),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
          BottomNavigationBarItem(icon: Icon(Icons.group), label: 'Daftar Anggota'),
          BottomNavigationBarItem(icon: Icon(Icons.help), label: 'Bantuan'),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
