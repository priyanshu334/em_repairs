import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'dart:io'; // To check file existence

class AppwriteService {
  late Client client;
  late Account account;
  late final Storage storage;

  AppwriteService() {
    client = Client()
      ..setEndpoint('https://cloud.appwrite.io/v1') // Replace with your Appwrite server endpoint
      ..setProject('6782414f002ff29452cc') // Replace with your project ID
      ..setSelfSigned(status: true); // For self-signed certificates in development

    account = Account(client);
    storage = Storage(client);
  }

  // Upload a file to a specific bucket
  Future<String> uploadFile(String bucketId, String filePath) async {
    try {
      // Check if the file exists
      final file = File(filePath);
      if (!await file.exists()) {
        throw Exception('File not found at the specified path.');
      }

      final uploadedFile = await storage.createFile(
        bucketId: bucketId,
        fileId: ID.unique(),
        file: InputFile.fromPath(path: filePath),
      );

      return uploadedFile.$id;  // Return the file ID after a successful upload
    } catch (e) {
      // Handle specific file or network-related exceptions
      throw Exception('File upload failed: $e');
    }
  }

  // Get file metadata using file ID

  // Get file content (download file)
  Future<File?> downloadFile(String bucketId, String fileId) async {
    try {
      final bytes = await storage.getFileDownload(bucketId: bucketId, fileId: fileId);
      final file = File('path_to_save/file.ext'); // Define path where the file should be saved
      await file.writeAsBytes(bytes);
      return file; // Return the file after saving it locally
    } catch (e) {
      throw Exception('Failed to download file: $e');
    }
  }

  // Get file preview (for images or other supported file types)
  Future<void> getFilePreview(String bucketId, String fileId) async {
    try {
      final bytes = await storage.getFilePreview(bucketId: bucketId, fileId: fileId);
      // Use the bytes to display a preview (e.g., Image.memory in Flutter)
      // This step would depend on the type of file you are dealing with.
    } catch (e) {
      throw Exception('Failed to get file preview: $e');
    }
  }

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
