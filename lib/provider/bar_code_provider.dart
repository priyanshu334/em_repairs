import 'package:em_repairs/models/bar_code_model.dart';
import 'package:flutter/material.dart';
import 'package:appwrite/appwrite.dart';
 // Import the BarcodeModel
import 'package:em_repairs/services/appwrite_service.dart'; // Import the AppwriteService

class BarcodeProvider with ChangeNotifier {
  final AppwriteService appwriteService;
  late Databases databases;

  // Database and collection IDs
  final String databaseId = 'your_database_id'; // Replace with your actual database ID
  final String collectionId = 'your_collection_id'; // Replace with your actual collection ID

  BarcodeProvider(this.appwriteService) {
    databases = Databases(appwriteService.client);
  }

  List<BarcodeModel> _barcodes = [];
  List<BarcodeModel> get barcodes => _barcodes;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Fetch all barcodes from Appwrite database
  Future<void> fetchBarcodes() async {
    _isLoading = true;
    notifyListeners();

    try {
      final result = await databases.listDocuments(
        databaseId: databaseId,
        collectionId: collectionId,
      );

      _barcodes = result.documents.map((doc) {
        return BarcodeModel.fromMap(doc.data, doc.$id); // Use BarcodeModel.fromMap to parse data
      }).toList();

      notifyListeners();
    } catch (e) {
      debugPrint('Error fetching barcodes: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Add a new barcode document to Appwrite
  Future<void> addBarcode(BarcodeModel barcode) async {
    try {
      await databases.createDocument(
        databaseId: databaseId,
        collectionId: collectionId,
        documentId: 'unique()', // Generate a unique ID for the document
        data: barcode.toMap(), // Convert the BarcodeModel to a map
      );

      _barcodes.add(barcode); // Add the new barcode to the list
      notifyListeners();
    } catch (e) {
      debugPrint('Error adding barcode: $e');
    }
  }

  // Update an existing barcode document
  Future<void> updateBarcode(String documentId, BarcodeModel barcode) async {
    try {
      await databases.updateDocument(
        databaseId: databaseId,
        collectionId: collectionId,
        documentId: documentId,
        data: barcode.toMap(),
      );

      // Find and update the barcode in the list
      final index = _barcodes.indexWhere((bc) => bc.id == documentId);
      if (index != -1) {
        _barcodes[index] = barcode;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error updating barcode: $e');
    }
  }

  // Delete a barcode document by ID
  Future<void> deleteBarcode(String documentId) async {
    try {
      await databases.deleteDocument(
        databaseId: databaseId,
        collectionId: collectionId,
        documentId: documentId,
      );

      _barcodes.removeWhere((bc) => bc.id == documentId); // Remove the deleted barcode from the list
      notifyListeners();
    } catch (e) {
      debugPrint('Error deleting barcode: $e');
    }
  }
}
