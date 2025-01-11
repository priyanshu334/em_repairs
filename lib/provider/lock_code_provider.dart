import 'package:em_repairs/models/lock_code_model.dart';
import 'package:em_repairs/services/appwrite_service.dart';
import 'package:flutter/material.dart';
import 'package:appwrite/appwrite.dart';

class LockCodeProvider with ChangeNotifier {
  final AppwriteService appwriteService;
  late final Databases databases;

  final String databaseId = '677fcede0019b442b2e7'; // Replace with your database ID
  final String collectionId = '67813a05000172754b85'; // Replace with your collection ID

  LockCodeProvider(this.appwriteService) {
    databases = Databases(appwriteService.client);
  }

  List<LockCodeModel> _lockCodes = [];
  List<LockCodeModel> get lockCodes => List.unmodifiable(_lockCodes);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Fetch all lock codes
  Future<void> fetchLockCodes() async {
    _setLoading(true);
    try {
      final result = await databases.listDocuments(
        databaseId: databaseId,
        collectionId: collectionId,
      );

      _lockCodes = result.documents.map((doc) {
        return LockCodeModel.fromMap(doc.data as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      debugPrint('Error fetching lock codes: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Add a new lock code
  Future<void> addLockCode(LockCodeModel lockCode) async {
    try {
      final createdDoc = await databases.createDocument(
        databaseId: databaseId,
        collectionId: collectionId,
        documentId: 'unique()', // Generate a unique ID
        data: lockCode.toMap(),
      );

      // Ensure the new document is added to the list
      _lockCodes.add(LockCodeModel.fromMap(createdDoc.data as Map<String, dynamic>));
      notifyListeners();
    } catch (e) {
      debugPrint('Error adding lock code: $e');
    }
  }

  // Update an existing lock code
  Future<void> updateLockCode(String documentId, LockCodeModel lockCode) async {
    try {
      await databases.updateDocument(
        databaseId: databaseId,
        collectionId: collectionId,
        documentId: documentId,
        data: lockCode.toMap(),
      );

      // Find and update the existing lock code
      final index = _lockCodes.indexWhere((lc) => lc.id == documentId);
      if (index != -1) {
        _lockCodes[index] = lockCode;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error updating lock code: $e');
    }
  }

  // Delete a lock code
  Future<void> deleteLockCode(String documentId) async {
    try {
      await databases.deleteDocument(
        databaseId: databaseId,
        collectionId: collectionId,
        documentId: documentId,
      );

      // Remove the lock code from the list
      _lockCodes.removeWhere((lc) => lc.id == documentId);
      notifyListeners();
    } catch (e) {
      debugPrint('Error deleting lock code: $e');
    }
  }

  // Set loading state
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
