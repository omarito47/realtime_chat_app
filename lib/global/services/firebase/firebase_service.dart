import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseService {
  // Upload image to Firebase Storage
  Future<String?> uploadImageToFirebase(
      File imageFile, String userEmail) async {
    String fileName =
        userEmail + '.jpg'; // Assuming the image file is in JPEG format
    Reference firebaseStorageRef =
        FirebaseStorage.instance.ref().child(fileName);

    try {
      UploadTask uploadTask = firebaseStorageRef.putFile(imageFile);
      TaskSnapshot taskSnapshot = await uploadTask;
      String downloadUrl = await taskSnapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

// Get image from Firebase Storage
  Future<String?> getImageFromFirebase(String userEmail) async {
    print("userEmail: " + userEmail);
    String fileName = userEmail + '.jpg';
    Reference firebaseStorageRef =
        FirebaseStorage.instance.ref().child(fileName);

    try {
      String downloadUrl = await firebaseStorageRef.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Error getting image: $e');
      return null;
    }
  }
}
