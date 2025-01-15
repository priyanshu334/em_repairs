import 'package:em_repairs/models/DeviceKycModels.dart';
import 'package:em_repairs/services/apwrite_service.dart';
import 'package:flutter/foundation.dart';
import 'package:appwrite/appwrite.dart';
 // Import DeviceKycModels

class DeviceKycProvider with ChangeNotifier {
  final AppwriteService _appwriteService;
  late Databases _databases;

  // Database and Collection IDs
  final String _databaseId = '678690d10024689b7151'; // Replace with your actual database ID
  final String _collectionId = '6786d370000d2c79140f'; // Replace with your actual collection ID

  DeviceKycProvider(this._appwriteService) {
    _databases = Databases(_appwriteService.client);
  }

  // List of DeviceKycModels
  List<DeviceKycModels> _deviceKycList = [];
  List<DeviceKycModels> get deviceKycList => _deviceKycList;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Save DeviceKycModels Data to Appwrite
 Future<void> saveDeviceKyc(DeviceKycModels model) async {
  _isLoading = true;
  notifyListeners();

  try {
    final response = await _databases.createDocument(
      databaseId: _databaseId,
      collectionId: _collectionId,
      documentId: ID.unique(), // Appwrite generates a unique ID
      data: model.toMap(),
    );

    // Remove the unnecessary `?? {}`
    final savedDeviceKyc = DeviceKycModels.fromMap(response.data, documentId: response.$id);
    _deviceKycList.add(savedDeviceKyc);
    notifyListeners();
  } catch (e) {
    debugPrint('Error saving device KYC: $e');
    throw Exception('Failed to save device KYC data.');
  } finally {
    _isLoading = false;
    notifyListeners();
  }
}

  // Retrieve a single DeviceKycModels by Document ID
  Future<DeviceKycModels> getDeviceKyc(String documentId) async {
    try {
      final response = await _databases.getDocument(
        databaseId: _databaseId,
        collectionId: _collectionId,
        documentId: documentId,
      );
      return DeviceKycModels.fromMap(response.data , documentId: response.$id);
    } catch (e) {
      debugPrint('Error fetching device KYC: $e');
      throw Exception('Failed to fetch device KYC data.');
    }
  }

  // List All DeviceKycModels
  Future<void> listDeviceKyc() async {
    _isLoading = true;
    notifyListeners();

    try {
      final result = await _databases.listDocuments(
        databaseId: _databaseId,
        collectionId: _collectionId,
      );

      _deviceKycList = result.documents.map((doc) {
        return DeviceKycModels.fromMap(doc.data , documentId: doc.$id);
      }).toList();

      notifyListeners();
    } catch (e) {
      debugPrint('Error listing device KYC: $e');
      throw Exception('Failed to list device KYC data.');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Update DeviceKycModels Data
  Future<void> updateDeviceKyc(String documentId, DeviceKycModels model) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _databases.updateDocument(
        databaseId: _databaseId,
        collectionId: _collectionId,
        documentId: documentId,
        data: model.toMap(),
      );

      final index = _deviceKycList.indexWhere((deviceKyc) => deviceKyc.id == documentId);
      if (index != -1) {
        _deviceKycList[index] = model.copyWith(id: documentId);
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error updating device KYC: $e');
      throw Exception('Failed to update device KYC data.');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Delete DeviceKycModels Data by Document ID
  Future<void> deleteDeviceKyc(String documentId) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _databases.deleteDocument(
        databaseId: _databaseId,
        collectionId: _collectionId,
        documentId: documentId,
      );

      _deviceKycList.removeWhere((deviceKyc) => deviceKyc.id == documentId);
      notifyListeners();
    } catch (e) {
      debugPrint('Error deleting device KYC: $e');
      throw Exception('Failed to delete device KYC data.');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
