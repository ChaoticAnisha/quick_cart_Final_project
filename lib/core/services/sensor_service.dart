import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:sensors_plus/sensors_plus.dart';

class SensorService {
  static final SensorService _instance = SensorService._internal();
  factory SensorService() => _instance;
  SensorService._internal();

  StreamSubscription<AccelerometerEvent>? _accelerometerSubscription;
  StreamSubscription<GyroscopeEvent>? _gyroscopeSubscription;

  final StreamController<bool> _shakeController =
      StreamController<bool>.broadcast();
  final StreamController<TiltDirection> _tiltController =
      StreamController<TiltDirection>.broadcast();

  Stream<bool> get shakeStream => _shakeController.stream;
  Stream<TiltDirection> get tiltStream => _tiltController.stream;

  double _lastX = 0, _lastY = 0, _lastZ = 0;
  int _shakeCount = 0;
  DateTime _lastShakeTime = DateTime.now();
  static const double _shakeThreshold = 15.0;
  static const int _shakeCountThreshold = 3;
  static const Duration _shakeDuration = Duration(milliseconds: 500);

  void startShakeDetection() {
    if (kIsWeb) return;
    _accelerometerSubscription = accelerometerEventStream().listen((event) {
      final now = DateTime.now();
      final timeDiff = now.difference(_lastShakeTime).inMilliseconds;

      if (timeDiff > 100) {
        final double deltaX = event.x - _lastX;
        final double deltaY = event.y - _lastY;
        final double deltaZ = event.z - _lastZ;

        final double acceleration = sqrt(
          deltaX * deltaX + deltaY * deltaY + deltaZ * deltaZ,
        );

        if (acceleration > _shakeThreshold) {
          _shakeCount++;

          if (_shakeCount >= _shakeCountThreshold &&
              now.difference(_lastShakeTime) < _shakeDuration) {
            _shakeController.add(true);
            _shakeCount = 0;
          }

          _lastShakeTime = now;
        } else if (now.difference(_lastShakeTime) > _shakeDuration) {
          _shakeCount = 0;
        }

        _lastX = event.x;
        _lastY = event.y;
        _lastZ = event.z;
      }
    });
  }

  void startTiltDetection() {
    if (kIsWeb) return;
    _gyroscopeSubscription = gyroscopeEventStream().listen((event) {
      if (event.x.abs() > 1.5) {
        if (event.x > 0) {
          _tiltController.add(TiltDirection.forward);
        } else {
          _tiltController.add(TiltDirection.backward);
        }
      } else if (event.y.abs() > 1.5) {
        if (event.y > 0) {
          _tiltController.add(TiltDirection.left);
        } else {
          _tiltController.add(TiltDirection.right);
        }
      }
    });
  }

  void dispose() {
    _accelerometerSubscription?.cancel();
    _gyroscopeSubscription?.cancel();
    _shakeController.close();
    _tiltController.close();
  }
}

enum TiltDirection { forward, backward, left, right }
