import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class CloudStorageService {
  final FirebaseStorage storage = FirebaseStorage.instance;

  Future<String?> saveUserImageToStorage(String userId, File file, String id) async {
    try {
      Reference reference =
          storage.ref().child('users/$userId/$id');
      UploadTask task = reference.putFile(
        File(file.path),
      );
      return task.then(
        (result) async => await result.ref.getDownloadURL(),
      );
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<void> deleteImageFromStorage(String userId, String itemId) async {
    final imageRef = storage.ref().child('users/$userId/$itemId');

    await imageRef.delete();
  }
}
