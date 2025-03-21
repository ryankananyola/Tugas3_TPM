import 'package:flutter/material.dart';

class NumberTypePage extends StatefulWidget {
  @override
  _NumberTypePageState createState() => _NumberTypePageState();
}

class _NumberTypePageState extends State<NumberTypePage> {
  final TextEditingController _numberController = TextEditingController();
  Map<String, bool>? _results;
  double? _inputNumber;
  String? _errorMessage; // Menyimpan pesan error

  void _checkNumberType() {
    String input = _numberController.text.trim();

    // Validasi input: jika kosong, tampilkan error
    if (input.isEmpty) {
      setState(() {
        _errorMessage = "Masukkan angka terlebih dahulu!";
        _results = null;
      });
      return;
    }

    // Coba konversi input menjadi angka
    double? number = double.tryParse(input);
    if (number == null) {
      setState(() {
        _errorMessage = "Input tidak valid! Masukkan angka saja.";
        _results = null;
      });
      return;
    }

    // Reset pesan error jika input valid
    _errorMessage = null;

    bool isDecimal = number % 1 != 0;
    bool isPositive = number > 0;
    bool isNegative = number < 0;
    bool isInteger = number % 1 == 0;
    bool isCacah = isPositive && isInteger;
    bool isPrime = isInteger && number > 1 && _isPrime(number.toInt());

    setState(() {
      _inputNumber = number;
      _results = {
        "Bilangan Prima": isPrime,
        "Bilangan Desimal": isDecimal,
        "Bilangan Bulat Positif": isInteger && isPositive,
        "Bilangan Bulat Negatif": isInteger && isNegative,
        "Bilangan Cacah": isCacah,
      };
    });
  }

  bool _isPrime(int num) {
    if (num < 2) return false;
    for (int i = 2; i * i <= num; i++) {
      if (num % i == 0) return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Jenis Bilangan")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Input Card
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      "Masukkan Angka",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: _numberController,
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Angka",
                        prefixIcon: Icon(Icons.numbers),
                        errorText: _errorMessage, // Tampilkan pesan error di bawah TextField
                      ),
                    ),
                    SizedBox(height: 15),
                    ElevatedButton(
                      onPressed: _checkNumberType,
                      child: Text("Cek Jenis Bilangan"),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),

            // Hasil Analisis Card
            if (_results != null)
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        "Hasil Analisis",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Angka: $_inputNumber",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      Divider(),
                      ..._results!.entries.map((entry) => _buildResultTile(entry.key, entry.value)),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultTile(String label, bool value) {
    return ListTile(
      leading: Icon(value ? Icons.check_circle : Icons.cancel, color: value ? Colors.green : Colors.red),
      title: Text(
        label,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
    );
  }
}
