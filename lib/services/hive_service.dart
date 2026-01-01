import 'package:hive_flutter/hive_flutter.dart';
import '../core/constants/app_boxes.dart';
import '../data/models/user_model.dart';

class HiveService {
  static Future<void> init() async {
    // Initialize Hive
    await Hive.initFlutter();

    // Register adapters
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(UserModelAdapter());
    }

    // Open boxes
    await Hive.openBox<UserModel>(AppBoxes.userBox);
    await Hive.openBox(AppBoxes.sessionBox);
  }

  static Future<void> closeAll() async {
    await Hive.close();
  }

  static Future<void> clearAll() async {
    final userBox = Hive.box<UserModel>(AppBoxes.userBox);
    final sessionBox = Hive.box(AppBoxes.sessionBox);

    await userBox.clear();
    await sessionBox.clear();
  }
}
