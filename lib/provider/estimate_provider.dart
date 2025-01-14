import 'package:appwrite/appwrite.dart';
import 'package:em_repairs/models/estimate_form.dart';
import 'package:em_repairs/services/apwrite_service.dart';
import 'package:flutter/material.dart';

class EstimateProvider extends ChangeNotifier {
  final AppwriteService _appwriteService;
  final List<EstimateModel> _estimates = [];
  EstimateModel? _selectedEstimate;

  static const String databaseId = '678241a4000c5def62aa'; // Replace with your actual database ID
  static const String collectionId = '6782c419001a0e4af7f5'; // Replace with your actual collection ID

  EstimateProvider(this._appwriteService);

  // Getter for estimates
  List<EstimateModel> get estimates => _estimates;

  // Getter for selected estimate
  EstimateModel? get selectedEstimate => _selectedEstimate;

  // Fetch estimates from Appwrite
  Future<void> fetchEstimates() async {
    try {
      final databases = Databases(_appwriteService.client);
      final response = await databases.listDocuments(
        databaseId: databaseId,
        collectionId: collectionId,
      );

      _estimates.clear();
      for (var doc in response.documents) {
        // Use fromMap to create EstimateModel instances
        _estimates.add(EstimateModel.fromMap(doc.data, documentId: doc.$id));
      }
      notifyListeners();
    } catch (e) {
      debugPrint('Error fetching estimates: $e');
    }
  }

  // Add an estimate to Appwrite and the list
  Future<void> addEstimate(EstimateModel estimate) async {
    try {
      final databases = Databases(_appwriteService.client);
      final response = await databases.createDocument(
        databaseId: databaseId,
        collectionId: collectionId,
        documentId: estimate.id ?? 'unique_id', // Let Appwrite generate a unique ID if null
        data: estimate.toMap(),
      );

      // Add the estimate with the newly generated ID
      _estimates.add(EstimateModel.fromMap(response.data, documentId: response.$id));
      notifyListeners();
    } catch (e) {
      debugPrint('Error adding estimate: $e');
    }
  }

  // Update an existing estimate in Appwrite and the list
  Future<void> updateEstimate(EstimateModel estimate) async {
    try {
      final databases = Databases(_appwriteService.client);
      await databases.updateDocument(
        databaseId: databaseId,
        collectionId: collectionId,
        documentId: estimate.id!, // Pass the 'id' directly, assuming it's not null for existing records
        data: estimate.toMap(),
      );

      final index = _estimates.indexWhere((e) => e.id == estimate.id);
      if (index != -1) {
        _estimates[index] = estimate;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error updating estimate: $e');
    }
  }

  // Remove an estimate from Appwrite and the list
  Future<void> removeEstimate(EstimateModel estimate) async {
    try {
      final databases = Databases(_appwriteService.client);
      await databases.deleteDocument(
        databaseId: databaseId,
        collectionId: collectionId,
        documentId: estimate.id!, // Pass the 'id' directly, assuming it's not null for existing records
      );

      _estimates.remove(estimate);
      notifyListeners();
    } catch (e) {
      debugPrint('Error removing estimate: $e');
    }
  }

  // Select an estimate
  void selectEstimate(EstimateModel estimate) {
    _selectedEstimate = estimate;
    notifyListeners();
  }

  // Remove selected estimate
  void removeSelectedEstimate() {
    _selectedEstimate = null;
    notifyListeners();
  }

  // Search estimates locally by repair cost or other fields
  List<EstimateModel> searchEstimates(String query) {
    return _estimates.where((estimate) {
      final costString = estimate.repairCost.toString();
      return costString.contains(query);
    }).toList();
  }

  // Fetch a single estimate by its ID
  Future<EstimateModel> getEstimateById(String id) async {
    try {
      final databases = Databases(_appwriteService.client);

      // Fetch the document for the single ID
      final response = await databases.getDocument(
        databaseId: databaseId,
        collectionId: collectionId,
        documentId: id,
      );

      // Return the EstimateModel created from the document data
      return EstimateModel.fromMap(response.toMap(), documentId: response.$id);
    } catch (e) {
      debugPrint('Error fetching estimate by ID: $e');
      throw Exception('Failed to fetch estimate.');
    }
  }
}
