import 'package:flutter/material.dart';
import 'dart:async';

class StopwatchPage extends StatefulWidget {
  const StopwatchPage({super.key});

  @override
  _StopwatchPageState createState() => _StopwatchPageState();
}

class _StopwatchPageState extends State<StopwatchPage> with WidgetsBindingObserver {
  Stopwatch _stopwatch = Stopwatch();
  Timer? _timer;
  DateTime? _startTime; // Menyimpan waktu terakhir saat mulai
  final List<Map<String, String>> _laps = [];
  int _previousLapTime = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _timer?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _resumeStopwatch();
    } else if (state == AppLifecycleState.paused) {
      _saveElapsedTime();
    }
  }

  void _startStopwatch() {
    if (!_stopwatch.isRunning) {
      _startTime = DateTime.now();
      _stopwatch.start();
      _startTimer();
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  void _pauseStopwatch() {
    if (_stopwatch.isRunning) {
      _stopwatch.stop();
      _timer?.cancel();
      _startTime = null;
      setState(() {});
    }
  }

  void _resetStopwatch() {
    _stopwatch.reset();
    _stopwatch.stop();
    _laps.clear();
    _previousLapTime = 0;
    _startTime = null;
    _timer?.cancel();
    setState(() {});
  }

  void _addLap() {
    if (_stopwatch.isRunning) {
      int currentTime = _stopwatch.elapsedMilliseconds;
      int lapDifference = currentTime - _previousLapTime;

      _laps.insert(0, {
        "total": _formatTime(currentTime),
        "interval": _formatTime(lapDifference),
      });

      _previousLapTime = currentTime;
      setState(() {});
    }
  }

  void _saveElapsedTime() {
    if (_stopwatch.isRunning) {
      _startTime = DateTime.now();
    }
  }

  void _resumeStopwatch() {
    if (_stopwatch.isRunning && _startTime != null) {
      final elapsed = DateTime.now().difference(_startTime!).inMilliseconds;
      _stopwatch.start();
      _stopwatch.elapsedMilliseconds + elapsed;
      _startTimer();
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
  Widget build(BuildContext context) {
    int displayedTime = _stopwatch.elapsedMilliseconds;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Stopwatch',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Waktu Stopwatch
            Text(
              _formatTime(displayedTime),
              style: const TextStyle(
                fontSize: 50,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 20),

            // Tombol Stopwatch
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

            // Daftar Lap
            Expanded(
              child: ListView.builder(
                itemCount: _laps.length,
                itemBuilder: (context, index) {
                  return Card(
                    color: Colors.grey[100],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.blueAccent,
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
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(text, style: const TextStyle(fontSize: 16)),
      ),
    );
  }
}
