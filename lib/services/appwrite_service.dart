import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AppwriteService {
  late Client client;
  late Account account;
  late final Storage storage;

  AppwriteService() {
    client = Client()
      ..setEndpoint('https://cloud.appwrite.io/v1') // Replace with your Appwrite server endpoint
      ..setProject('677fcd0b0004104a6316') // Replace with your project ID
      ..setSelfSigned(status: true); // For self-signed certificates in development

    account = Account(client);
    storage = Storage(client);
  }

  // Upload a file to a specific bucket
  Future<String> uploadFile(String bucketId, String filePath) async {
    try {
      final file = await storage.createFile(
        bucketId: bucketId,
        fileId: ID.unique(),
        file: InputFile.fromPath(path: filePath),
      );
      return file.$id;  // Return the file ID after a successful upload
    } catch (e) {
      throw Exception('File upload failed: $e');
    }
  }

  // Get file details using file ID


  // Delete a file from the bucket
  Future<void> deleteFile(String bucketId, String fileId) async {
    try {
      await storage.deleteFile(bucketId: bucketId, fileId: fileId);
    } catch (e) {
      throw Exception('File deletion failed: $e');
    }
  }

  // Sign out the user (Optional)
  Future<void> signOut() async {
    try {
      await account.deleteSession(sessionId: 'current');
    } catch (e) {
      throw Exception('Sign out failed: $e');
    }
  }
}
