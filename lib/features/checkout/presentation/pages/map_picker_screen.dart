import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:latlong2/latlong.dart';

class MapPickerResult {
  final LatLng position;
  final String address;
  final String city;
  final String postcode;

  const MapPickerResult({
    required this.position,
    required this.address,
    this.city = '',
    this.postcode = '',
  });
}

class MapPickerScreen extends StatefulWidget {
  final LatLng? initialPosition;
  const MapPickerScreen({super.key, this.initialPosition});

  @override
  State<MapPickerScreen> createState() => _MapPickerScreenState();
}

class _MapPickerScreenState extends State<MapPickerScreen> {
  static const _kDefault = LatLng(27.7172, 85.3240); // Kathmandu
  static const _kOrange = Color(0xFFFFA500);

  late final MapController _mapController;
  late LatLng _picked;
  String _address = 'Tap map or drag pin to choose location';
  String _city = '';
  String _postcode = '';
  bool _loadingLocation = false;
  bool _loadingAddress = false;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _picked = widget.initialPosition ?? _kDefault;
    _reverseGeocode(_picked);
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  Future<void> _goToCurrentLocation() async {
    setState(() => _loadingLocation = true);
    try {
      LocationPermission perm = await Geolocator.checkPermission();
      if (perm == LocationPermission.denied) {
        perm = await Geolocator.requestPermission();
      }
      if (perm == LocationPermission.deniedForever) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permission denied')),
          );
        }
        return;
      }
      final pos = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.high, timeLimit: Duration(seconds: 10)),
      );
      final latlng = LatLng(pos.latitude, pos.longitude);
      _mapController.move(latlng, 16);
      setState(() => _picked = latlng);
      await _reverseGeocode(latlng);
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not get current location')),
        );
      }
    } finally {
      if (mounted) setState(() => _loadingLocation = false);
    }
  }

  Future<void> _reverseGeocode(LatLng pos) async {
    setState(() => _loadingAddress = true);
    try {
      final url = Uri.parse(
        'https://nominatim.openstreetmap.org/reverse'
        '?lat=${pos.latitude}&lon=${pos.longitude}'
        '&format=json&addressdetails=1',
      );
      final res = await http
          .get(url, headers: {'Accept-Language': 'en'})
          .timeout(const Duration(seconds: 8));
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body) as Map<String, dynamic>;
        final addr = data['address'] as Map<String, dynamic>? ?? {};
        final parts = <String>[
          if (addr['road'] != null) addr['road'] as String,
          if (addr['neighbourhood'] != null) addr['neighbourhood'] as String,
          if (addr['suburb'] != null) addr['suburb'] as String,
          if (addr['city'] != null)
            addr['city'] as String
          else if (addr['town'] != null)
            addr['town'] as String,
          if (addr['state'] != null) addr['state'] as String,
        ];
        setState(() {
          _address = parts.isNotEmpty
              ? parts.join(', ')
              : data['display_name']?.toString() ?? '${pos.latitude}, ${pos.longitude}';
          _city = (addr['city'] ?? addr['town'] ?? addr['village'] ?? addr['county'] ?? '') as String;
          _postcode = (addr['postcode'] ?? '') as String;
          _loadingAddress = false;
        });
        return;
      }
    } catch (_) {}
    setState(() {
      _address = '${pos.latitude.toStringAsFixed(5)}, ${pos.longitude.toStringAsFixed(5)}';
      _city = '';
      _postcode = '';
      _loadingAddress = false;
    });
  }

  void _onTap(TapPosition _, LatLng pos) {
    setState(() => _picked = pos);
    _reverseGeocode(pos);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _picked,
              initialZoom: 15,
              onTap: _onTap,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.quickcart.app',
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: _picked,
                    width: 48,
                    height: 56,
                    child: const Column(
                      children: [
                        Icon(Icons.location_pin, color: _kOrange, size: 42),
                        SizedBox(height: 2),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Material(
                elevation: 4,
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Icon(Icons.arrow_back_ios_new_rounded,
                            size: 20, color: Colors.black87),
                      ),
                      const SizedBox(width: 10),
                      const Expanded(
                        child: Text(
                          'Pick Delivery Location',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          Positioned(
            right: 16,
            bottom: 160,
            child: FloatingActionButton.small(
              heroTag: 'my_location',
              backgroundColor: Colors.white,
              onPressed: _loadingLocation ? null : _goToCurrentLocation,
              child: _loadingLocation
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: _kOrange),
                    )
                  : const Icon(Icons.my_location, color: _kOrange),
            ),
          ),

          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                boxShadow: [
                  BoxShadow(color: Colors.black12, blurRadius: 20, spreadRadius: 2),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Deliver to',
                      style: TextStyle(fontSize: 12, color: Colors.grey)),
                  const SizedBox(height: 6),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.location_on, color: _kOrange, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _loadingAddress
                            ? const SizedBox(
                                height: 16,
                                child: LinearProgressIndicator(
                                    color: _kOrange,
                                    backgroundColor: Color(0xFFFFF8DC)),
                              )
                            : Text(
                                _address,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                  height: 1.4,
                                ),
                              ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: _loadingAddress
                          ? null
                          : () => Navigator.pop(
                                context,
                                MapPickerResult(
                                  position: _picked,
                                  address: _address,
                                  city: _city,
                                  postcode: _postcode,
                                ),
                              ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _kOrange,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Confirm Location',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
