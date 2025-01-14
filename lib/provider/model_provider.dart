import 'package:appwrite/appwrite.dart';
import 'package:em_repairs/models/model_details_model.dart';
import 'package:em_repairs/services/apwrite_service.dart';
import 'package:flutter/foundation.dart';

class ModelDetailsProvider extends ChangeNotifier {
  final AppwriteService _appwriteService;
  final List<ModelDetailsModel> _models = [];
  ModelDetailsModel? _selectedModel;

  static const String databaseId = '678241a4000c5def62aa'; // Replace with your database ID
  static const String collectionId = '6782c5440010c9b9c763'; // Replace with your collection ID

  ModelDetailsProvider(this._appwriteService);

  // Getter for model details list
  List<ModelDetailsModel> get models => _models;

  // Getter for the selected model
  ModelDetailsModel? get selectedModel => _selectedModel;

  /// Fetch model details from Appwrite
  Future<void> fetchModels() async {
    try {
      final databases = Databases(_appwriteService.client);
      final response = await databases.listDocuments(
        databaseId: databaseId,
        collectionId: collectionId,
      );

      _models.clear();
      for (var doc in response.documents) {
        _models.add(ModelDetailsModel.fromMap(doc.data)); // No need for document ID here as it's part of the document
      }
      notifyListeners();
    } catch (e) {
      debugPrint('Error fetching models: $e');
    }
  }

  /// Add model details to Appwrite and the list
  Future<void> addModel(ModelDetailsModel model) async {
    try {
      final databases = Databases(_appwriteService.client);

      // If the model's ID is null, Appwrite will generate it
      final response = await databases.createDocument(
        databaseId: databaseId,
        collectionId: collectionId,
        documentId: model.id ?? 'unique_document_id', // Use a default or let Appwrite generate it
        data: model.toMap(),
      );

      // If the model's ID was null, update it with the generated ID
      final newModel = ModelDetailsModel.fromMap(response.data);
      _models.add(newModel); // Add the new model with the generated ID
      notifyListeners();
    } catch (e) {
      debugPrint('Error adding model: $e');
    }
  }

  /// Update a model in Appwrite and the local list
  Future<void> updateModel(ModelDetailsModel model) async {
    try {
      if (model.id == null) {
        throw 'Model ID is required for update';
      }

      final databases = Databases(_appwriteService.client);
      await databases.updateDocument(
        databaseId: databaseId,
        collectionId: collectionId,
        documentId: model.id!, // Use `id` as the unique identifier
        data: model.toMap(),
      );

      // Find and update the model in the local list
      final index = _models.indexWhere((m) => m.id == model.id);
      if (index != -1) {
        _models[index] = model;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error updating model: $e');
    }
  }

  /// Remove a model from Appwrite and the list
  Future<void> removeModel(ModelDetailsModel model) async {
    try {
      if (model.id == null) {
        throw 'Model ID is required for removal';
      }

      final databases = Databases(_appwriteService.client);
      await databases.deleteDocument(
        databaseId: databaseId,
        collectionId: collectionId,
        documentId: model.id!, // Use `id` as the unique identifier
      );

      _models.remove(model);
      notifyListeners();
    } catch (e) {
      debugPrint('Error removing model: $e');
    }
  }

  /// Select a model
  void selectModel(ModelDetailsModel model) {
    _selectedModel = model;
    notifyListeners();
  }

  /// Deselect the selected model
  void deselectModel() {
    _selectedModel = null;
    notifyListeners();
  }

  /// Search models locally
  List<ModelDetailsModel> searchModels(String query) {
    return _models.where((model) {
      final searchFields = [
        model.frontImagePath,
        model.backImagePath,
        model.sideImage1Path,
        model.sideImage2Path,
      ];
      return searchFields.any((field) => field?.contains(query) ?? false);
    }).toList();
  }
}
