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

  await Hive.initFlutter();

  if (!Hive.isAdapterRegistered(AppBoxes.userHiveModelTypeId)) {
    Hive.registerAdapter(UserHiveModelAdapter());
  }
  if (!Hive.isAdapterRegistered(AppBoxes.orderHiveModelTypeId)) {
    Hive.registerAdapter(OrderHiveModelAdapter());
  }

  await Future.wait([
    Hive.openBox<UserHiveModel>(AppBoxes.userBox),
    Hive.openBox<Map>(AppBoxes.cartBox),
    Hive.openBox(AppBoxes.sessionBox),
    Hive.openBox<OrderHiveModel>(AppBoxes.orderBox),
    Hive.openBox<String>(AppBoxes.productBox),
    Hive.openBox<String>(AppBoxes.categoryBox),
    Hive.openBox<String>(AppBoxes.wishlistBox),
    Hive.openBox<String>(AppBoxes.recentlyViewedBox),
  ]);

  await PermissionService().requestCameraAndPhotos();

  runApp(const ProviderScope(child: App()));
}
