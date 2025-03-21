import 'package:flutter/material.dart';

class TimeConverterPage extends StatefulWidget {
  @override
  _TimeConverterPageState createState() => _TimeConverterPageState();
}

class _TimeConverterPageState extends State<TimeConverterPage> {
  final TextEditingController _yearController = TextEditingController();
  int? hours, minutes, seconds;

  void _convertTime() {
    int? years = int.tryParse(_yearController.text);
    if (years != null && years >= 0) {
      setState(() {
        hours = years * 365 * 24;
        minutes = hours! * 60;
        seconds = minutes! * 60;
      });
    }
  }

  String formatNumber(int number) {
    return number.toString().replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (match) => '.',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Konversi Waktu')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Masukkan jumlah tahun:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _yearController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Tahun',
                prefixIcon: Icon(Icons.timer),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(onPressed: _convertTime, child: Text('Konversi')),
            SizedBox(height: 20),
            if (hours != null)
              Column(
                children: [
                  Text(
                    'Hasil Konversi:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  _buildResultTile('Jam', hours!),
                  _buildResultTile('Menit', minutes!),
                  _buildResultTile('Detik', seconds!),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultTile(String label, int value) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.symmetric(vertical: 5),
      child: ListTile(
        leading: Icon(Icons.access_time),
        title: Text(
          '$label: ${formatNumber(value)}',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
