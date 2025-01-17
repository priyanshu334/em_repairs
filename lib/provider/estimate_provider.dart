import 'package:appwrite/appwrite.dart';
import 'package:em_repairs/models/estimate_form.dart';
import 'package:em_repairs/services/apwrite_service.dart';
import 'package:flutter/material.dart';

class EstimateProvider extends ChangeNotifier {
  final AppwriteService _appwriteService;
  final List<EstimateModel> _estimates = [];
  EstimateModel? _selectedEstimate;

  static const String databaseId = '678690d10024689b7151'; // Replace with your actual database ID
  static const String collectionId = '6786923b00052373fc1e'; // Replace with your actual collection ID

  EstimateProvider(this._appwriteService);

  // Getter for estimates
  List<EstimateModel> get estimates => _estimates;

  // Getter for selected estimate
  EstimateModel? get selectedEstimate => _selectedEstimate;

  // Fetch estimates from Appwrite
  Future<void> fetchEstimates({int limit = 20, int offset = 0}) async {
    try {
      final databases = Databases(_appwriteService.client);
      final response = await databases.listDocuments(
        databaseId: databaseId,
        collectionId: collectionId,
        queries: [
          Query.limit(limit),
          Query.offset(offset),
        ],
      );

      final newEstimates = response.documents.map((doc) {
        return EstimateModel.fromMap(doc.data, documentId: doc.$id);
      }).toList();

      if (offset == 0) _estimates.clear();
      _estimates.addAll(newEstimates);
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
        documentId: ID.unique(), // Appwrite generates a unique ID
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
        documentId: estimate.id, // Pass the 'id' directly, assuming it's not null
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
        documentId: estimate.id,
      );

      _estimates.remove(estimate);
      notifyListeners();
    } catch (e) {
      debugPrint('Error removing estimate: $e');
    }
  }

  // Select an estimate
  void selectEstimate(EstimateModel estimate) {
    if (_selectedEstimate != estimate) {
      _selectedEstimate = estimate;
      notifyListeners();
    }
  }

  // Remove selected estimate
  void removeSelectedEstimate() {
    _selectedEstimate = null;
    notifyListeners();
  }

  // Search estimates locally by repair cost, advancePaid, or pickupTime
  List<EstimateModel> searchEstimates(String query) {
    query = query.toLowerCase();
    return _estimates.where((estimate) {
      return estimate.repairCost.toString().contains(query) ||
          estimate.advancePaid.toString().contains(query) ||
          (estimate.pickupTime?.toLowerCase().contains(query) ?? false);
    }).toList();
  }

  // Fetch a single estimate by its ID
  Future<EstimateModel> getEstimateById(String id) async {
    try {
      final databases = Databases(_appwriteService.client);
      final response = await databases.getDocument(
        databaseId: databaseId,
        collectionId: collectionId,
        documentId: id,
      );

      return EstimateModel.fromMap(response.toMap(), documentId: response.$id);
    } catch (e) {
      debugPrint('Error fetching estimate by ID: $e');
      throw Exception('Failed to fetch estimate.');
    }
  }
}
