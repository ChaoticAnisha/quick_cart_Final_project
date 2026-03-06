import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../core/services/sensor_service.dart';

class SensorScreen extends StatefulWidget {
  const SensorScreen({super.key});

  @override
  State<SensorScreen> createState() => _SensorScreenState();
}

class _SensorScreenState extends State<SensorScreen>
    with TickerProviderStateMixin {
  final _sensorService = SensorService();

  StreamSubscription<bool>? _shakeSub;
  StreamSubscription<TiltDirection>? _tiltSub;

  bool _shakeDetected = false;
  TiltDirection? _tiltDirection;

  late AnimationController _shakeAnim;
  late AnimationController _pulseAnim;
  Timer? _shakeResetTimer;

  @override
  void initState() {
    super.initState();
    _shakeAnim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _pulseAnim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);

    _sensorService.startShakeDetection();
    _sensorService.startTiltDetection();

    _shakeSub = _sensorService.shakeStream.listen((_) {
      setState(() => _shakeDetected = true);
      _shakeAnim.forward(from: 0);
      _shakeResetTimer?.cancel();
      _shakeResetTimer =
          Timer(const Duration(seconds: 2), () {
        if (mounted) setState(() => _shakeDetected = false);
      });
    });

    _tiltSub = _sensorService.tiltStream.listen((dir) {
      setState(() => _tiltDirection = dir);
    });
  }

  @override
  void dispose() {
    _shakeSub?.cancel();
    _tiltSub?.cancel();
    _shakeAnim.dispose();
    _pulseAnim.dispose();
    _shakeResetTimer?.cancel();
    super.dispose();
  }

  IconData _tiltIcon(TiltDirection dir) {
    switch (dir) {
      case TiltDirection.forward:
        return Icons.arrow_upward_rounded;
      case TiltDirection.backward:
        return Icons.arrow_downward_rounded;
      case TiltDirection.left:
        return Icons.arrow_back_rounded;
      case TiltDirection.right:
        return Icons.arrow_forward_rounded;
    }
  }

  String _tiltLabel(TiltDirection dir) {
    switch (dir) {
      case TiltDirection.forward:
        return 'Tilting Forward';
      case TiltDirection.backward:
        return 'Tilting Backward';
      case TiltDirection.left:
        return 'Tilting Left';
      case TiltDirection.right:
        return 'Tilting Right';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final primary = const Color(0xFFFFA500);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Sensor Demo',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // ── Shake card ──────────────────────────────────
            AnimatedBuilder(
              animation: _shakeAnim,
              builder: (_, child) {
                final offset =
                    Curves.elasticOut.transform(_shakeAnim.value) * 8;
                return Transform.translate(
                  offset: Offset(offset * (_shakeAnim.value > 0.5 ? -1 : 1), 0),
                  child: child,
                );
              },
              child: _SensorCard(
                color: cardColor,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: primary.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(Icons.vibration, color: primary, size: 24),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'Shake Detection',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: _shakeDetected
                          ? Column(
                              key: const ValueKey('shake_yes'),
                              children: [
                                AnimatedBuilder(
                                  animation: _pulseAnim,
                                  builder: (_, __) => Container(
                                    width: 80 + _pulseAnim.value * 10,
                                    height: 80 + _pulseAnim.value * 10,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: primary
                                          .withValues(alpha: 0.15 + _pulseAnim.value * 0.1),
                                    ),
                                    child:
                                        Icon(Icons.vibration, color: primary, size: 40),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  'SHAKE DETECTED!',
                                  style: TextStyle(
                                    color: primary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                              ],
                            )
                          : Column(
                              key: const ValueKey('shake_no'),
                              children: [
                                Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: isDark
                                        ? const Color(0xFF2C2C2C)
                                        : Colors.grey.shade100,
                                  ),
                                  child: Icon(Icons.phone_android,
                                      color: Colors.grey.shade400, size: 36),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  'Shake your phone…',
                                  style: TextStyle(
                                      color: Colors.grey.shade500, fontSize: 14),
                                ),
                              ],
                            ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // ── Tilt card ───────────────────────────────────
            _SensorCard(
              color: cardColor,
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFF5C6BC0).withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.screen_rotation,
                            color: Color(0xFF5C6BC0), size: 24),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Tilt Detection',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: _tiltDirection == null
                        ? Column(
                            key: const ValueKey('tilt_none'),
                            children: [
                              Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: isDark
                                      ? const Color(0xFF2C2C2C)
                                      : Colors.grey.shade100,
                                ),
                                child: Icon(Icons.screen_rotation,
                                    color: Colors.grey.shade400, size: 36),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'Tilt your phone…',
                                style: TextStyle(
                                    color: Colors.grey.shade500, fontSize: 14),
                              ),
                            ],
                          )
                        : Column(
                            key: ValueKey(_tiltDirection),
                            children: [
                              Container(
                                width: 80,
                                height: 80,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(0xFF5C6BC0),
                                ),
                                child: Icon(
                                  _tiltIcon(_tiltDirection!),
                                  color: Colors.white,
                                  size: 40,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                _tiltLabel(_tiltDirection!),
                                style: const TextStyle(
                                  color: Color(0xFF5C6BC0),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                  ),
                  const SizedBox(height: 16),
                  // Compass-style indicator
                  _TiltCompass(direction: _tiltDirection),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ── Info card ───────────────────────────────────
            _SensorCard(
              color: cardColor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color:
                              const Color(0xFF26A69A).withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.info_outline,
                            color: Color(0xFF26A69A), size: 24),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'How It Works',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  _InfoRow(
                    icon: Icons.vibration,
                    text:
                        'Shake detection uses the accelerometer. Shake the phone 3× quickly to trigger.',
                  ),
                  const SizedBox(height: 8),
                  _InfoRow(
                    icon: Icons.screen_rotation,
                    text:
                        'Tilt detection uses the gyroscope. Rotate the phone in any direction.',
                  ),
                  const SizedBox(height: 8),
                  _InfoRow(
                    icon: Icons.web_asset_off,
                    text: 'Sensors are disabled on web — physical device required.',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Helper widgets ──────────────────────────────────────────────────────────

class _SensorCard extends StatelessWidget {
  const _SensorCard({required this.child, required this.color});
  final Widget child;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _TiltCompass extends StatelessWidget {
  const _TiltCompass({this.direction});
  final TiltDirection? direction;

  @override
  Widget build(BuildContext context) {
    const size = 100.0;
    const center = size / 2;

    double dotX = center;
    double dotY = center;
    if (direction != null) {
      const offset = 28.0;
      switch (direction!) {
        case TiltDirection.forward:
          dotY = center - offset;
          break;
        case TiltDirection.backward:
          dotY = center + offset;
          break;
        case TiltDirection.left:
          dotX = center - offset;
          break;
        case TiltDirection.right:
          dotX = center + offset;
          break;
      }
    }

    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _CompassPainter(dotX: dotX, dotY: dotY),
      ),
    );
  }
}

class _CompassPainter extends CustomPainter {
  _CompassPainter({required this.dotX, required this.dotY});
  final double dotX, dotY;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // outer ring
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = const Color(0xFF5C6BC0).withValues(alpha: 0.12)
        ..style = PaintingStyle.fill,
    );
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = const Color(0xFF5C6BC0).withValues(alpha: 0.4)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );
    // crosshair
    final crossPaint = Paint()
      ..color = const Color(0xFF5C6BC0).withValues(alpha: 0.25)
      ..strokeWidth = 1;
    canvas.drawLine(
        Offset(center.dx, 0), Offset(center.dx, size.height), crossPaint);
    canvas.drawLine(
        Offset(0, center.dy), Offset(size.width, center.dy), crossPaint);

    // moving dot
    canvas.drawCircle(
      Offset(dotX, dotY),
      14,
      Paint()..color = const Color(0xFF5C6BC0),
    );
  }

  @override
  bool shouldRepaint(_CompassPainter old) =>
      old.dotX != dotX || old.dotY != dotY;
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.text});
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: const Color(0xFF26A69A)),
        const SizedBox(width: 8),
        Expanded(
          child: Text(text,
              style: TextStyle(
                  fontSize: 13, color: Colors.grey.shade600, height: 1.4)),
        ),
      ],
    );
  }
}
