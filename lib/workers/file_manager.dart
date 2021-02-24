import 'dart:io';

import 'package:permission_handler/permission_handler.dart';

class FileManagerService {
  static Future<bool> getFilePermissions() async {
    PermissionStatus storagePermissionState = await Permission.storage.status;
    if (storagePermissionState.isDenied) {
      var requestStatus = await Permission.storage.request();
      return requestStatus.isGranted;
    }
    return storagePermissionState.isGranted;
  }

  static Future<Directory> getStorageFolder() async {
    var permissionStatus = await FileManagerService.getFilePermissions();
    if (permissionStatus) {
      final String path = "/storage/emulated/0/Locie";
      bool folderExists = await Directory(path).exists();
      if (!folderExists) {
        return await Directory(path).create(recursive: true);
      }
      return Directory(path);
    }
    return null;
  }
}
