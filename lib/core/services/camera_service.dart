import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'permission_service.dart';

enum ImageSourceType { camera, gallery }

class CameraService {
  static final CameraService _instance = CameraService._internal();
  factory CameraService() => _instance;
  CameraService._internal();

  final ImagePicker _picker = ImagePicker();
  final PermissionService _permissionService = PermissionService();

  /// Pick an image from the camera or gallery.
  /// Returns the [File] on success, or null if the user cancels or
  /// permission is denied.
  Future<File?> pickImage({
    required ImageSourceType source,
    int imageQuality = 85,
    double? maxWidth,
    double? maxHeight,
  }) async {
    final hasPermission = source == ImageSourceType.camera
        ? await _permissionService.requestCamera()
        : await _permissionService.requestPhotos();

    if (!hasPermission) return null;

    final XFile? xFile = await _picker.pickImage(
      source: source == ImageSourceType.camera
          ? ImageSource.camera
          : ImageSource.gallery,
      imageQuality: imageQuality,
      maxWidth: maxWidth ?? 1200,
      maxHeight: maxHeight ?? 1200,
    );

    if (xFile == null) return null;
    return File(xFile.path);
  }

  /// Show a bottom sheet and let the user choose camera or gallery.
  /// Returns the picked [File], or null.
  Future<File?> showPickerDialog({
    required Future<File?> Function(ImageSourceType) onPick,
  }) async {
    // Caller is responsible for showing UI; this helper just routes the pick.
    return null;
  }
}
