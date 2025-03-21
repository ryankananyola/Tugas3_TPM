import 'package:flutter/material.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class StopwatchPage extends StatefulWidget {
  const StopwatchPage({super.key});

  @override
  _StopwatchPageState createState() => _StopwatchPageState();
}

class _StopwatchPageState extends State<StopwatchPage> {
  final Stopwatch _stopwatch = Stopwatch();
  Timer? _timer;
  final List<Map<String, String>> _laps = [];
  int _previousLapTime = 0;
  int _storedElapsedTime = 0;
  bool _wasRunning = false;

  @override
  void initState() {
    super.initState();
    _loadStopwatchState();
  }

  Future<void> _loadStopwatchState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _storedElapsedTime = prefs.getInt('elapsedTime') ?? 0;
    _wasRunning = prefs.getBool('isRunning') ?? false;
    
    if (_wasRunning) {
      int lastStartTime = prefs.getInt('lastStartTime') ?? 0;
      int currentTime = DateTime.now().millisecondsSinceEpoch;
      int elapsedSinceLastStart = currentTime - lastStartTime;

      _stopwatch.start();
      _stopwatch.elapsedMilliseconds;
      _stopwatch.stop();

      _storedElapsedTime += elapsedSinceLastStart;
      _stopwatch.reset();
      _stopwatch.start();
      _stopwatch.elapsedMilliseconds;
      _stopwatch.stop();

      _startStopwatch(resume: true);
    } else {
      _stopwatch.reset();
      _stopwatch.start();
      _stopwatch.elapsedMilliseconds;
      _stopwatch.stop();
    }
    setState(() {});
  }

  Future<void> _saveStopwatchState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('elapsedTime', _stopwatch.elapsedMilliseconds + _storedElapsedTime);
    await prefs.setBool('isRunning', _stopwatch.isRunning);
    if (_stopwatch.isRunning) {
      await prefs.setInt('lastStartTime', DateTime.now().millisecondsSinceEpoch);
    }
  }

  void _startStopwatch({bool resume = false}) {
    if (!_stopwatch.isRunning) {
      _stopwatch.start();
      _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
        setState(() {});
      });

      if (!resume) {
        _storedElapsedTime = 0;
        _saveStopwatchState();
      }
    }
  }

  void _pauseStopwatch() {
    if (_stopwatch.isRunning) {
      _stopwatch.stop();
      _saveStopwatchState();
      setState(() {});
    }
  }

  void _resetStopwatch() async {
    _stopwatch.reset();
    _stopwatch.stop();
    _laps.clear();
    _previousLapTime = 0;
    _storedElapsedTime = 0;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('elapsedTime');
    await prefs.remove('isRunning');
    await prefs.remove('lastStartTime');
    setState(() {});
  }

  void _addLap() {
    if (_stopwatch.isRunning) {
      int currentTime = _stopwatch.elapsedMilliseconds + _storedElapsedTime;
      int lapDifference = currentTime - _previousLapTime;

      _laps.insert(0, {
        "total": _formatTime(currentTime),
        "interval": _formatTime(lapDifference),
      });

      _previousLapTime = currentTime;
      setState(() {});
    }
  }

  String _formatTime(int milliseconds) {
    int minutes = (milliseconds ~/ 60000) % 60;
    int seconds = (milliseconds ~/ 1000) % 60;
    int milli = (milliseconds % 1000) ~/ 10;
    return '${minutes.toString().padLeft(2, '0')}:'
        '${seconds.toString().padLeft(2, '0')}.'
        '${milli.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _timer?.cancel();
    _saveStopwatchState();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int displayedTime = _stopwatch.elapsedMilliseconds + _storedElapsedTime;

    return Scaffold(
      appBar: AppBar(title: const Text('Stopwatch')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              _formatTime(displayedTime),
              style: const TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildButton("Start", Colors.green, _startStopwatch),
                _buildButton("Pause", Colors.orange, _pauseStopwatch),
                _buildButton("Reset", Colors.red, _resetStopwatch),
                _buildButton("Lap", Colors.blue, _addLap),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _laps.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.blue,
                        child: Text(
                          '${_laps.length - index}',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      title: Text(
                        "Lap ${_laps.length - index}: ${_laps[index]['total']}",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        "Interval: ${_laps[index]['interval']}",
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(String text, Color color, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(text, style: const TextStyle(fontSize: 16)),
      ),
    );
  }
}
