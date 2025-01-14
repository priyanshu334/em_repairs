import 'package:em_repairs/models/bar_code_model.dart';
import 'package:em_repairs/services/apwrite_service.dart';
import 'package:flutter/material.dart';
import 'package:appwrite/appwrite.dart';

class BarcodeProvider with ChangeNotifier {
  final AppwriteService appwriteService;
  late Databases databases;

  // Database and collection IDs
  final String databaseId = '678690d10024689b7151'; // Replace with your actual database ID
  final String collectionId = '678691ce0004d7cb4818'; // Replace with your actual collection ID

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
        return BarcodeModel.fromMap(doc.data, );
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
      final response = await databases.createDocument(
        databaseId: databaseId,
        collectionId: collectionId,
        documentId: ID.unique(), // Use Appwrite to generate a unique ID
        data: barcode.toMap(),
      );

      final newBarcode = BarcodeModel.fromMap(response.data,);
      _barcodes.add(newBarcode);
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

      final index = _barcodes.indexWhere((bc) => bc.id == documentId);
      if (index != -1) {
        _barcodes[index] = barcode.copyWith(id: documentId);
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

      _barcodes.removeWhere((bc) => bc.id == documentId);
      notifyListeners();
    } catch (e) {
      debugPrint('Error deleting barcode: $e');
    }
  }

  // Fetch a single barcode document by ID
  Future<BarcodeModel?> fetchBarcodeById(String id) async {
    try {
      final response = await databases.getDocument(
        databaseId: databaseId,
        collectionId: collectionId,
        documentId: id,
      );

      final barcode = BarcodeModel.fromMap(response.data);
      return barcode;
    } catch (e) {
      debugPrint('Error fetching barcode by ID: $e');
      return null; // Return null if document not found or an error occurs
    }
  }
}
