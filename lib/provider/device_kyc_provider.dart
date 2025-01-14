  import 'package:em_repairs/services/apwrite_service.dart';
  import 'package:flutter/foundation.dart';
  import 'package:appwrite/appwrite.dart';
  import 'package:em_repairs/models/device_kyc_model.dart'; // Import DeviceKycModel

  class DeviceKycProvider with ChangeNotifier {
    final AppwriteService _appwriteService;
    late Databases _databases;

    // Database and Collection IDs
    final String _databaseId = '678690d10024689b7151'; // Replace with your actual database ID
    final String _collectionId = '6786a9240006edeb92ea'; // Replace with your actual collection ID

    DeviceKycProvider(this._appwriteService) {
      _databases = Databases(_appwriteService.client);
    }

    // List of DeviceKycModel
    List<DeviceKycModel> _deviceKycList = [];
    List<DeviceKycModel> get deviceKycList => _deviceKycList;

    bool _isLoading = false;
    bool get isLoading => _isLoading;

    // Save DeviceKycModel Data to Appwrite
    Future<void> saveDeviceKyc(DeviceKycModel model) async {
      _isLoading = true;
      notifyListeners();

      try {
        final response = await _databases.createDocument(
          databaseId: _databaseId,
          collectionId: _collectionId,
          documentId: model.deviceId ?? 'uniqueDeviceId', // Generate unique ID
          data: model.toMap(),
        );

        final savedDeviceKyc = DeviceKycModel.fromMap(response.data ?? {});
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

    // Retrieve a single DeviceKycModel by ID
    Future<DeviceKycModel> getDeviceKyc(String documentId) async {
      try {
        final response = await _databases.getDocument(
          databaseId: _databaseId,
          collectionId: _collectionId,
          documentId: documentId,
        );
        return DeviceKycModel.fromMap(response.data ?? {});
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
          return DeviceKycModel.fromMap(doc.data ?? {});
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

    // Update DeviceKycModel Data
    Future<void> updateDeviceKyc(String documentId, DeviceKycModel model) async {
      _isLoading = true;
      notifyListeners();

      try {
        await _databases.updateDocument(
          databaseId: _databaseId,
          collectionId: _collectionId,
          documentId: documentId,
          data: model.toMap(),
        );

        final index = _deviceKycList.indexWhere((deviceKyc) => deviceKyc.deviceId == documentId);
        if (index != -1) {
          _deviceKycList[index] = model.copyWith(deviceId: documentId);
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

    // Delete DeviceKycModel Data by ID
    Future<void> deleteDeviceKyc(String documentId) async {
      _isLoading = true;
      notifyListeners();

      try {
        await _databases.deleteDocument(
          databaseId: _databaseId,
          collectionId: _collectionId,
          documentId: documentId,
        );

        _deviceKycList.removeWhere((deviceKyc) => deviceKyc.deviceId == documentId);
        notifyListeners();
      } catch (e) {
        debugPrint('Error deleting device KYC: $e');
        throw Exception('Failed to delete device KYC data.');
      } finally {
        _isLoading = false;
        notifyListeners();
      }
    }

    // Fetch multiple DeviceKycModels by their IDs
    Future<DeviceKycModel> getDeviceKycById(String deviceId) async {
      _isLoading = true;
      notifyListeners();

      try {
        final result = await _databases.listDocuments(
          databaseId: _databaseId,
          collectionId: _collectionId,
          queries: [Query.equal('deviceId', [deviceId])],
        );

        if (result.documents.isEmpty) {
          throw Exception('Device KYC with this ID not found.');
        }

        // Since we are querying with one ID, we expect only one result
        return DeviceKycModel.fromMap(result.documents.first.data ?? {});
      } catch (e) {
        debugPrint('Error fetching device KYC by ID: $e');
        throw Exception('Failed to fetch device KYC data.');
      } finally {
        _isLoading = false;
        notifyListeners();
      }
    }

    // Sort DeviceKycModels by Device ID
  
  }
