import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'core/constants/app_boxes.dart';
import 'core/services/permission_service.dart';
import 'features/auth/data/models/user_hive_model.dart';
import 'features/orders/data/models/order_hive_model.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();

  // Register Hive TypeAdapters
  if (!Hive.isAdapterRegistered(AppBoxes.userHiveModelTypeId)) {
    Hive.registerAdapter(UserHiveModelAdapter());
  }
  if (!Hive.isAdapterRegistered(AppBoxes.orderHiveModelTypeId)) {
    Hive.registerAdapter(OrderHiveModelAdapter());
  }

  // Open boxes eagerly so they are ready before first use
  await Future.wait([
    Hive.openBox<UserHiveModel>(AppBoxes.userBox),
    Hive.openBox<Map>(AppBoxes.cartBox),
    Hive.openBox(AppBoxes.sessionBox),
    Hive.openBox<OrderHiveModel>(AppBoxes.orderBox),
  ]);

  // Request camera and storage permissions on startup
  await PermissionService().requestCameraAndPhotos();

  runApp(const ProviderScope(child: App()));
}
