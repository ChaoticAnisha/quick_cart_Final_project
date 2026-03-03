import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  static final PermissionService _instance = PermissionService._internal();
  factory PermissionService() => _instance;
  PermissionService._internal();

  Future<bool> requestCamera() async {
    if (kIsWeb) return true;
    final status = await Permission.camera.request();
    return status.isGranted;
  }

  Future<bool> requestPhotos() async {
    if (kIsWeb) return true;

    final mediaImages = await Permission.photos.request();
    if (mediaImages.isGranted) return true;

    final storage = await Permission.storage.request();
    return storage.isGranted;
  }

  Future<bool> requestCameraAndPhotos() async {
    if (kIsWeb) return true;
    final camera = await requestCamera();
    final photos = await requestPhotos();
    return camera && photos;
  }

  Future<bool> hasCameraPermission() async {
    if (kIsWeb) return true;
    return await Permission.camera.isGranted;
  }

  Future<bool> hasPhotosPermission() async {
    if (kIsWeb) return true;
    if (await Permission.photos.isGranted) return true;
    return await Permission.storage.isGranted;
  }

  Future<void> openSettings() async {
    if (kIsWeb) return;
    await openAppSettings();
  }
}
