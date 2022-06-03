import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';

class FileStorage extends GetxController {
  late FirebaseStorage storage;
  late Reference storageRef;
  FileStorage() {
    storage = FirebaseStorage.instance;
  }
  Future<String> uploadFile(String filePath, String uploadPath) async {
    File file = File(filePath);
    storageRef = storage.ref(uploadPath);
    await storageRef.putFile(file);
    String downloadUrl = await storageRef.getDownloadURL();
    return downloadUrl;
    // try {
    //   storageRef = storage.ref(uploadPath);
    //   await storageRef.putFile(file);
    //   String downloadUrl = await storageRef.getDownloadURL();
    //   return downloadUrl;
    // } on FirebaseException catch (e) {
    //   print('$e');
    // }
  }
}
