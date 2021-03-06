import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:locie/helper/minions.dart';

class CloudStorage {
  FirebaseStorage firestorage;

  CloudStorage() {
    firestorage = FirebaseStorage.instance;
  }

  UploadTask uploadFile(File file) {
    return firestorage.ref('media/${generateId()}').putFile(file);
  }

  UploadTask uploadBytes(Uint8List list) {
    return firestorage.ref("media/${generateId()}").putData(list);
  }

  Future<String> getDownloadUrl(UploadTask task) async {
    var completedTask = await task;
    return await completedTask.ref.getDownloadURL();
  }
}
