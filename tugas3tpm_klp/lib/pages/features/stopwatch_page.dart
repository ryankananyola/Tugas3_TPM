import 'package:flutter/material.dart';
import 'dart:async';

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

  void _startStopwatch() {
    if (!_stopwatch.isRunning) {
      _stopwatch.start();
      _timer = Timer.periodic(Duration(milliseconds: 100), (timer) {
        setState(() {});
      });
    }
  }

  void _pauseStopwatch() {
    if (_stopwatch.isRunning) {
      _stopwatch.stop();
      setState(() {});
    }
  }

  void _resetStopwatch() {
    _stopwatch.reset();
    _stopwatch.stop();
    _laps.clear();
    _previousLapTime = 0;
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Stopwatch')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Display Stopwatch
            Text(
              _formatTime(_stopwatch.elapsedMilliseconds),
              style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),

            // Control Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildButton("Start", Colors.green, _startStopwatch),
                _buildButton("Pause", Colors.orange, _pauseStopwatch),
                _buildButton("Reset", Colors.red, _resetStopwatch),
                _buildButton("Lap", Colors.blue, _addLap),
              ],
            ),
            SizedBox(height: 20),

            // Lap List
            Expanded(
              child: ListView.builder(
                itemCount: _laps.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 4),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.blue,
                        child: Text(
                          '${_laps.length - index}',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      title: Text(
                        "Lap ${_laps.length - index}: ${_laps[index]['total']}",
                        style: TextStyle(fontWeight: FontWeight.bold),
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
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(text, style: TextStyle(fontSize: 16)),
      ),
    );
  }
}