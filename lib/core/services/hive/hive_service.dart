import 'package:hive_flutter/hive_flutter.dart';

class HiveService {
  static Future<void> init() async {
    // Initialize Hive
    await Hive.initFlutter();
  }

  static Future<void> closeAll() async {
    await Hive.close();
  }
}
