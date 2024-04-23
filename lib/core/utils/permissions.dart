import 'package:permission_handler/permission_handler.dart';

Future<bool> requestPermission(Permission permission) async {
  final status = await permission.status;
  if (status.isGranted) {
    return true;
  } else {
    if (status.isPermanentlyDenied) {
      openAppSettings();
      return false;
    }
    final result = await permission.request();
    if (result.isGranted) {
      return true;
    } else {
      return false;
    }
  }
}
