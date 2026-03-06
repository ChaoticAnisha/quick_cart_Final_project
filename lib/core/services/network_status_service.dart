import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../api/api_endpoints.dart';

final networkStatusProvider =
    StateNotifierProvider<NetworkStatusNotifier, bool>((ref) {
  return NetworkStatusNotifier();
});

/// Polls the API host every 8 seconds and reports true (online) / false (offline).
class NetworkStatusNotifier extends StateNotifier<bool> {
  NetworkStatusNotifier() : super(true) {
    if (!kIsWeb) _startMonitoring();
  }

  Timer? _timer;

  void _startMonitoring() {
    _check();
    _timer = Timer.periodic(const Duration(seconds: 8), (_) => _check());
  }

  Future<void> _check() async {
    try {
      final uri = Uri.parse(ApiEndpoints.baseUrl);
      final host = uri.host;
      final port = uri.hasPort ? uri.port : 80;
      final socket = await Socket.connect(
        host,
        port,
        timeout: const Duration(seconds: 3),
      );
      socket.destroy();
      if (!state) state = true;
    } catch (_) {
      if (state) state = false;
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
