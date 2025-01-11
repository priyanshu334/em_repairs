import 'package:appwrite/appwrite.dart';
import 'package:em_repairs/models/service_center_model.dart';
import 'package:flutter/material.dart';
import 'package:em_repairs/services/appwrite_service.dart';

class ServiceCenterProvider extends ChangeNotifier {
  final AppwriteService _appwriteService;
  final List<ServiceCenterModel> _serviceCenters = [];
  ServiceCenterModel? _selectedServiceCenter;

  static const String databaseId = '677fcede0019b442b2e7'; // Replace with your actual database ID
  static const String collectionId = '677fd5b70026d5a23c8c'; // Replace with your actual collection ID

  ServiceCenterProvider(this._appwriteService);

  // Getter for service centers
  List<ServiceCenterModel> get serviceCenters => _serviceCenters;

  // Getter for the selected service center
  ServiceCenterModel? get selectedServiceCenter => _selectedServiceCenter;

  // Fetch service centers from Appwrite
  Future<void> fetchServiceCenters() async {
    try {
      final databases = Databases(_appwriteService.client);
      final response = await databases.listDocuments(
        databaseId: databaseId,
        collectionId: collectionId,
      );

      _serviceCenters.clear();
      for (var doc in response.documents) {
        _serviceCenters.add(ServiceCenterModel(
          id: doc.$id,
          name: doc.data['name'],
          contactNumber: doc.data['contactNumber'],
          address: doc.data['address'],
        ));
      }
      notifyListeners();
    } catch (e) {
      debugPrint('Error fetching service centers: $e');
    }
  }

  // Add a service center to Appwrite and the list
  Future<void> addServiceCenter(ServiceCenterModel serviceCenter) async {
    try {
      final databases = Databases(_appwriteService.client);
      final response = await databases.createDocument(
        databaseId: databaseId,
        collectionId: collectionId,
        documentId: 'unique()', // Let Appwrite generate a unique ID
        data: {
          'name': serviceCenter.name,
          'contactNumber': serviceCenter.contactNumber,
          'address': serviceCenter.address,
        },
      );

      _serviceCenters.add(ServiceCenterModel(
        id: response.$id,
        name: serviceCenter.name,
        contactNumber: serviceCenter.contactNumber,
        address: serviceCenter.address,
      ));
      notifyListeners();
    } catch (e) {
      debugPrint('Error adding service center: $e');
    }
  }

  // Update a service center in Appwrite and the list
  Future<void> updateServiceCenter(ServiceCenterModel serviceCenter) async {
    try {
      final databases = Databases(_appwriteService.client);
      final response = await databases.updateDocument(
        databaseId: databaseId,
        collectionId: collectionId,
        documentId: serviceCenter.id!, // Use the service center ID to update
        data: {
          'name': serviceCenter.name,
          'contactNumber': serviceCenter.contactNumber,
          'address': serviceCenter.address,
        },
      );

      // Update the service center locally in the list
      final index = _serviceCenters.indexWhere((sc) => sc.id == serviceCenter.id);
      if (index != -1) {
        _serviceCenters[index] = serviceCenter; // Replace the old data with the updated one
      }

      notifyListeners();
    } catch (e) {
      debugPrint('Error updating service center: $e');
    }
  }

  // Remove a service center from Appwrite and the list
  Future<void> removeServiceCenter(ServiceCenterModel serviceCenter) async {
    try {
      final databases = Databases(_appwriteService.client);
      await databases.deleteDocument(
        databaseId: databaseId,
        collectionId: collectionId,
        documentId: serviceCenter.id!,
      );

      _serviceCenters.remove(serviceCenter);
      notifyListeners();
    } catch (e) {
      debugPrint('Error removing service center: $e');
    }
  }

  // Select a service center
  void selectServiceCenter(ServiceCenterModel serviceCenter) {
    _selectedServiceCenter = serviceCenter;
    notifyListeners();
  }

  // Remove selected service center
  void removeSelectedServiceCenter() {
    _selectedServiceCenter = null;
    notifyListeners();
  }

  // Search service centers locally
  List<ServiceCenterModel> searchServiceCenters(String query) {
    return _serviceCenters
        .where((serviceCenter) =>
            serviceCenter.name.toLowerCase().contains(query.toLowerCase()) ||
            serviceCenter.contactNumber.contains(query))
        .toList();
  }
}
