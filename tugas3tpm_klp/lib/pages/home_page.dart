import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'features/stopwatch_page.dart';
import 'features/number_type_page.dart';
import 'features/tracking_lbs_page.dart';
import 'features/time_converter_page.dart';
import 'member_page.dart';
import 'help_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _greetingMessage = "Selamat datang di Aplikasi!";
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          HomeContent(greetingMessage: _greetingMessage),
          MemberPage(),
          HelpPage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
          BottomNavigationBarItem(icon: Icon(Icons.group), label: 'Daftar Anggota'),
          BottomNavigationBarItem(icon: Icon(Icons.help), label: 'Bantuan'),
        ],
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  final String greetingMessage;

  const HomeContent({super.key, required this.greetingMessage});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            greetingMessage,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView(
              children: [
                _buildMenuItem(context, Icons.timer, "Stopwatch", StopwatchPage()),
                _buildMenuItem(context, Icons.numbers, "Jenis Bilangan", NumberTypePage()),
                _buildMenuItem(context, Icons.location_on, "Tracking LBS", TrackingLBSPage()),
                _buildMenuItem(context, Icons.access_time, "Konversi Waktu", TimeConverterPage()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, IconData icon, String title, Widget page) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12)
      ),
      elevation: 2,
      child: ListTile(
        leading: Icon(icon, color: Colors.black87),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500
          )
        ),
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => page)),
      ),
    );
  }
}