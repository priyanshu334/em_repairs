import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as appwrite_models;
import 'package:em_repairs/models/accessories_model.dart';
import 'package:em_repairs/services/apwrite_service.dart';
import 'package:flutter/material.dart';

class AccessoriesProvider with ChangeNotifier {
  final AppwriteService _appwriteService;
  late Databases _databases;

  // Database and Collection IDs
  final String _databaseId = '678690d10024689b7151'; // Replace with your actual database ID
  final String _collectionId = '6786912d00153a010c61'; // Replace with your actual collection ID

  AccessoriesProvider(this._appwriteService) {
    _databases = Databases(_appwriteService.client);
  }

  // List of accessories
  List<AccessoriesModel> _accessories = [];
  List<AccessoriesModel> get accessories => _accessories;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Save Accessories Data to Appwrite
  Future<void> saveAccessories(AccessoriesModel model) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _databases.createDocument(
        databaseId: _databaseId,
        collectionId: _collectionId,
        documentId: ID.unique(), // Let Appwrite generate a unique ID
        data: model.toMap(),
      );

      final savedAccessory =
          AccessoriesModel.fromMap(response.data, id: response.$id);
      _accessories.add(savedAccessory);
      notifyListeners();
    } catch (e) {
      debugPrint('Error saving accessories: $e');
      throw Exception('Failed to save accessories data.');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Retrieve a single accessory document by ID
  Future<AccessoriesModel> getAccessories(String documentId) async {
    try {
      final response = await _databases.getDocument(
        databaseId: _databaseId,
        collectionId: _collectionId,
        documentId: documentId,
      );

      return AccessoriesModel.fromMap(response.data, id: response.$id);
    } catch (e) {
      debugPrint('Error fetching accessories: $e');
      throw Exception('Failed to fetch accessories data.');
    }
  }

  // Fetch Accessories by ID (New Method)
  Future<AccessoriesModel?> fetchAccessoriesById(String id) async {
    try {
      final response = await _databases.getDocument(
        databaseId: _databaseId,
        collectionId: _collectionId,
        documentId: id,
      );

      final accessory = AccessoriesModel.fromMap(response.data, id: response.$id);
      return accessory;
    } catch (e) {
      debugPrint('Error fetching accessories by ID: $e');
      return null; // Return null if the document is not found or an error occurs
    }
  }

  // List All Accessories Documents
  Future<void> listAccessories() async {
    _isLoading = true;
    notifyListeners();

    try {
      final result = await _databases.listDocuments(
        databaseId: _databaseId,
        collectionId: _collectionId,
      );

      _accessories = result.documents.map((doc) {
        return AccessoriesModel.fromMap(doc.data, id: doc.$id);
      }).toList();

      notifyListeners();
    } catch (e) {
      debugPrint('Error listing accessories: $e');
      throw Exception('Failed to list accessories data.');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Update Accessories Data
Future<void> updateAccessories(AccessoriesModel accessory) async {
  try {
    final databases = Databases(_appwriteService.client);
    await databases.updateDocument(
      databaseId: _databaseId,
      collectionId: _collectionId,
      documentId: accessory.id!, // Ensure accessory has an ID
      data: accessory.toMap(),
    );

    // Find the index of the accessory in the local list
    final index = _accessories.indexWhere((a) => a.id == accessory.id);
    if (index != -1) {
      _accessories[index] = accessory; // Update the accessory in the local list
      notifyListeners();
    }

    debugPrint('Accessory updated: ${accessory.id}');
  } catch (e) {
    debugPrint('Error updating accessory: ${e.toString()}');
  }
}


  // Delete Accessories Data by ID
  Future<void> deleteAccessories(String documentId) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _databases.deleteDocument(
        databaseId: _databaseId,
        collectionId: _collectionId,
        documentId: documentId,
      );

      _accessories.removeWhere((accessory) => accessory.id == documentId);
      notifyListeners();
    } catch (e) {
      debugPrint('Error deleting accessories: $e');
      throw Exception('Failed to delete accessories data.');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
