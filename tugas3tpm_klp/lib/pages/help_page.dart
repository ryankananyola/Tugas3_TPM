import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_page.dart';

class HelpPage extends StatefulWidget {
  const HelpPage({super.key});

  @override
  State<HelpPage> createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  Future<void> _logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  final List<Map<String, dynamic>> _helpItems = [
    {
      'title': 'Stopwatch',
      'description': 'Fitur stopwatch memungkinkan pengguna mengukur waktu dengan fungsi start, pause, dan reset.'
    },
    {
      'title': 'Number Type',
      'description': 'Fitur ini digunakan untuk menentukan jenis bilangan seperti prima, genap, atau ganjil.'
    },
    {
      'title': 'Tracking LBS',
      'description': 'Fitur ini menggunakan Location-Based Services untuk melacak lokasi pengguna secara real-time.'
    },
    {
      'title': 'Time Converter',
      'description': 'Fitur ini digunakan untuk mengonversi waktu antara berbagai satuan seperti detik, menit, dan jam.'
    },
    {
      'title': 'Favorite Sites',
      'description': 'Fitur ini memungkinkan pengguna untuk menyimpan dan mengakses situs favorit dengan mudah.'
    },
  ];

  int? _expandedIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(16),
              color: Colors.black,
              width: double.infinity,
              child: Text(
                "BANTUAN",
                style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    ..._helpItems.asMap().entries.map((entry) {
                      int index = entry.key;
                      Map<String, dynamic> item = entry.value;
                      return Card(
                        elevation: 3,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: ExpansionTile(
                          key: Key(item['title']),
                          title: Text(
                            item['title'],
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          initiallyExpanded: _expandedIndex == index,
                          onExpansionChanged: (bool expanded) {
                            setState(() {
                              _expandedIndex = expanded ? index : null;
                            });
                          },
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Text(
                                item['description'],
                                style: TextStyle(fontSize: 14, color: Colors.black87),
                              ),
                            )
                          ],
                        ),
                      );
                    }),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () => _logout(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        elevation: 3,
                      ),
                      child: const Text(
                        "Logout",
                        style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
