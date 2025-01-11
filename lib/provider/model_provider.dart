import 'package:appwrite/appwrite.dart';
import 'package:em_repairs/models/model_details_model.dart';
import 'package:em_repairs/services/appwrite_service.dart';
import 'package:flutter/foundation.dart';
 // Replace with your actual path

class ModelDetailsProvider extends ChangeNotifier {
  final AppwriteService _appwriteService;
  final List<ModelDetailsModel> _models = [];
  ModelDetailsModel? _selectedModel;

  static const String databaseId = 'YOUR_DATABASE_ID'; // Replace with your database ID
  static const String collectionId = 'YOUR_COLLECTION_ID'; // Replace with your collection ID

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
        _models.add(ModelDetailsModel.fromMap(doc.data));
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
      final response = await databases.createDocument(
        databaseId: databaseId,
        collectionId: collectionId,
        documentId: 'unique()', // Let Appwrite generate a unique ID
        data: model.toMap(),
      );

      // Add the model to the local list
      _models.add(ModelDetailsModel.fromMap(response.data));
      notifyListeners();
    } catch (e) {
      debugPrint('Error adding model: $e');
    }
  }

  /// Remove a model from Appwrite and the list
  Future<void> removeModel(ModelDetailsModel model) async {
    try {
      final databases = Databases(_appwriteService.client);
      await databases.deleteDocument(
        databaseId: databaseId,
        collectionId: collectionId,
        documentId: model.frontImagePath!, // Assuming `frontImagePath` as a unique identifier
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
