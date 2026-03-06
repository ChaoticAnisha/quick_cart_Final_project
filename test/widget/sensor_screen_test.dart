import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quick_cart/features/sensors/presentation/pages/sensor_screen.dart';
import 'helpers/test_helpers.dart';

void main() {
  // Suppress MissingPluginException from sensors_plus in test environment.
  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('dev.fluttercommunity.plus/sensors/accelerometer'),
      (_) async => null,
    );
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('dev.fluttercommunity.plus/sensors/gyroscope'),
      (_) async => null,
    );
  });

  // ── Test 1: AppBar title ─────────────────────────────────────────────────
  testWidgets('shows Sensor Demo app bar title', (tester) async {
    await pumpScreen(tester, const SensorScreen());
    await tester.pump();

    expect(find.text('Sensor Demo'), findsOneWidget);
  });

  // ── Test 2: Shake Detection card ─────────────────────────────────────────
  testWidgets('shows Shake Detection card', (tester) async {
    await pumpScreen(tester, const SensorScreen());
    await tester.pump();

    expect(find.text('Shake Detection'), findsOneWidget);
  });

  // ── Test 3: Tilt Detection card ──────────────────────────────────────────
  testWidgets('shows Tilt Detection card', (tester) async {
    await pumpScreen(tester, const SensorScreen());
    await tester.pump();

    expect(find.text('Tilt Detection'), findsOneWidget);
  });

  // ── Test 4: How It Works card ────────────────────────────────────────────
  testWidgets('shows How It Works info card', (tester) async {
    await pumpScreen(tester, const SensorScreen());
    await tester.pump();

    expect(find.text('How It Works'), findsOneWidget);
  });

  // ── Test 5: Default idle messages ────────────────────────────────────────
  testWidgets('shows idle prompts before any sensor events', (tester) async {
    await pumpScreen(tester, const SensorScreen());
    await tester.pump();

    expect(find.text('Shake your phone…'), findsOneWidget);
    expect(find.text('Tilt your phone…'), findsOneWidget);
  });

  // ── Test 6: Info card accelerometer text ─────────────────────────────────
  testWidgets('shows accelerometer info text', (tester) async {
    await pumpScreen(tester, const SensorScreen());
    await tester.pump();

    expect(
      find.textContaining('accelerometer'),
      findsOneWidget,
    );
  });

  // ── Test 7: Info card gyroscope text ─────────────────────────────────────
  testWidgets('shows gyroscope info text', (tester) async {
    await pumpScreen(tester, const SensorScreen());
    await tester.pump();

    expect(
      find.textContaining('gyroscope'),
      findsOneWidget,
    );
  });
}
