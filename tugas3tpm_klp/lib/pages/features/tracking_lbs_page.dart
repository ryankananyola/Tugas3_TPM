import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

class TrackingLBSPage extends StatefulWidget {
  const TrackingLBSPage({super.key});

  @override
  _TrackingLBSPageState createState() => _TrackingLBSPageState();
}

class _TrackingLBSPageState extends State<TrackingLBSPage> {
  LatLng? _currentPosition;
  String _statusMessage = "Menunggu lokasi...";
  bool _isLoading = false;
  final MapController _mapController = MapController();

  @override
  void initState() {
    super.initState();
    _determinePosition();
    _trackPositionStream(); // Aktifkan tracking real-time
  }

  // Fungsi mendapatkan lokasi awal pengguna dengan akurasi tinggi
  Future<void> _determinePosition() async {
    setState(() {
      _isLoading = true;
      _statusMessage = "Mengecek izin lokasi...";
    });

    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        _statusMessage = "Layanan lokasi tidak aktif.";
        _isLoading = false;
      });
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          _statusMessage = "Izin lokasi ditolak.";
          _isLoading = false;
        });
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() {
        _statusMessage =
            "Izin lokasi ditolak permanen. Aktifkan di pengaturan.";
        _isLoading = false;
      });
      return;
    }

    // Ambil lokasi dengan akurasi tinggi
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best,
      timeLimit: const Duration(seconds: 5),
    );

    setState(() {
      _currentPosition = LatLng(position.latitude, position.longitude);
      _statusMessage = "Lokasi diperbarui";
      _isLoading = false;
    });

    if (_currentPosition != null) {
      _mapController.move(_currentPosition!, 18.0);
    }
  }

  // Fungsi untuk tracking lokasi secara real-time
  void _trackPositionStream() {
    Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.best,
        distanceFilter: 2, // Update hanya jika bergerak ≥2 meter
      ),
    ).listen((Position position) {
      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);
        _statusMessage =
            "Lokasi diperbarui: ${position.latitude}, ${position.longitude}";
      });

      if (_currentPosition != null) {
        _mapController.move(_currentPosition!, 18.0);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tracking LBS')),
      body: Stack(
        children: [
          _currentPosition != null
              ? FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    center: _currentPosition ?? LatLng(-6.2088, 106.8456),
                    zoom: 18.0,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                      subdomains: ['a', 'b', 'c'],
                    ),
                    MarkerLayer(
                      markers: _currentPosition != null
                          ? [
                              Marker(
                                point: _currentPosition!,
                                width: 40,
                                height: 40,
                                child: const Icon(
                                  Icons.location_pin,
                                  size: 40,
                                  color: Colors.red,
                                ),
                              ),
                            ]
                          : [],
                    ),
                  ],
                )
              : Center(
                  child: Text(
                    _statusMessage,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
          Positioned(
            bottom: 20,
            left: 20,
            child: FloatingActionButton(
              backgroundColor: Colors.blue,
              onPressed: _determinePosition,
              child: const Icon(Icons.my_location, color: Colors.white),
            ),
          ),
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}