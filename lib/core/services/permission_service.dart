import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  static final PermissionService _instance = PermissionService._internal();
  factory PermissionService() => _instance;
  PermissionService._internal();

  /// Request camera permission. Returns true if granted (or on web, returns true silently).
  Future<bool> requestCamera() async {
    if (kIsWeb) return true;
    final status = await Permission.camera.request();
    return status.isGranted;
  }

  /// Request photo / storage permission.
  /// Handles Android 13+ (READ_MEDIA_IMAGES) and older (READ_EXTERNAL_STORAGE).
  Future<bool> requestPhotos() async {
    if (kIsWeb) return true;

    // Android 13+ uses Permission.photos (READ_MEDIA_IMAGES)
    final mediaImages = await Permission.photos.request();
    if (mediaImages.isGranted) return true;

    // Fallback for Android < 13 / iOS
    final storage = await Permission.storage.request();
    return storage.isGranted;
  }

  /// Request both camera and photo permissions.
  Future<bool> requestCameraAndPhotos() async {
    if (kIsWeb) return true;
    final camera = await requestCamera();
    final photos = await requestPhotos();
    return camera && photos;
  }

  /// Check camera permission without prompting.
  Future<bool> hasCameraPermission() async {
    if (kIsWeb) return true;
    return await Permission.camera.isGranted;
  }

  /// Check photo permission without prompting.
  Future<bool> hasPhotosPermission() async {
    if (kIsWeb) return true;
    if (await Permission.photos.isGranted) return true;
    return await Permission.storage.isGranted;
  }

  /// Open app settings so the user can manually grant a denied permission.
  Future<void> openSettings() async {
    if (kIsWeb) return;
    await openAppSettings();
  }
}
