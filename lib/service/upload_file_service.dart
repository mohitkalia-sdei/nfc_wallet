import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';

class PdfUploader {
  final FirebaseStorage _storage = FirebaseStorage.instance;
 Future<String?> uploadFileAndReturnUrl(String userId, String field, File file) async {
    final fileName = "$field-${DateTime.now().millisecondsSinceEpoch}.pdf";
    try {
      final storageRef = _storage.ref().child("pdfs/$userId/$fileName");
      await storageRef.putFile(file);

      final downloadUrl = await storageRef.getDownloadURL();
      print("PDF uploaded successfully: $downloadUrl");

      return downloadUrl;
    } catch (e) {
      print("Error uploading PDF: $e");
      return null;
    }
  }
}
