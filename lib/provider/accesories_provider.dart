import 'package:flutter/foundation.dart';
import 'package:appwrite/appwrite.dart';
import 'package:em_repairs/models/accessories_model.dart'; // Import AccessoriesModel
import 'package:em_repairs/services/appwrite_service.dart'; // Import AppwriteService

class AccessoriesProvider with ChangeNotifier {
  final AppwriteService _appwriteService;
  late Databases _databases;

  // Database and Collection IDs
  final String _databaseId = '677fcede0019b442b2e7'; // Replace with your actual database ID
  final String _collectionId = '678151b8002f60debc19'; // Replace with your actual collection ID

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
      await _databases.createDocument(
        databaseId: _databaseId,
        collectionId: _collectionId,
        documentId: 'unique()', // Appwrite will generate a unique ID
        data: model.toMap(),
      );
      _accessories.add(model); // Add the newly saved accessory to the list
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
      return AccessoriesModel.fromMap(response.data);
    } catch (e) {
      debugPrint('Error fetching accessories: $e');
      throw Exception('Failed to fetch accessories data.');
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
        return AccessoriesModel.fromMap(doc.data); // Map document data to AccessoriesModel
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
  Future<void> updateAccessories(String documentId, AccessoriesModel model) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _databases.updateDocument(
        databaseId: _databaseId,
        collectionId: _collectionId,
        documentId: documentId,
        data: model.toMap(),
      );

      // Update the accessory in the local list
      final index = _accessories.indexWhere((accessory) => accessory.id == documentId);
      if (index != -1) {
        _accessories[index] = model;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error updating accessories: $e');
      throw Exception('Failed to update accessories data.');
    } finally {
      _isLoading = false;
      notifyListeners();
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

      // Remove the deleted accessory from the list
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
