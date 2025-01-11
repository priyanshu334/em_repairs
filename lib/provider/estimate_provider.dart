import 'package:appwrite/appwrite.dart';
import 'package:em_repairs/models/estimate_form_model.dart';
import 'package:em_repairs/services/appwrite_service.dart';
import 'package:flutter/material.dart';

class EstimateProvider extends ChangeNotifier {
  final AppwriteService _appwriteService;
  final List<EstimateModel> _estimates = [];
  EstimateModel? _selectedEstimate;

  static const String databaseId = '677fcede0019b442b2e7'; // Replace with your actual database ID
  static const String collectionId = '677fd41800345133d677'; // Replace with your actual collection ID

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
        _estimates.add(EstimateModel.fromMap(doc.data, doc.$id));
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
        documentId: 'unique()', // Let Appwrite generate a unique ID
        data: estimate.toMap(),
      );

      _estimates.add(EstimateModel.fromMap(response.data, response.$id));
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
        documentId: estimate.id!,
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
        documentId: estimate.id!,
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
}
