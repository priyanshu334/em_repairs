import 'package:appwrite/appwrite.dart';
import 'package:em_repairs/models/service_center_model.dart';
import 'package:em_repairs/services/apwrite_service.dart';
import 'package:flutter/material.dart';

class ServiceCenterProvider extends ChangeNotifier {
  final AppwriteService _appwriteService;
  final List<ServiceCenterModel> _serviceCenters = [];
  ServiceCenterModel? _selectedServiceCenter;

  static const String databaseId = '678241a4000c5def62aa'; // Replace with your actual database ID
  static const String collectionId = '6782c71f002c4fbbddb1'; // Replace with your actual collection ID

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
        // Ensure 'id' is passed to the model by including documentId
        _serviceCenters.add(ServiceCenterModel.fromMap(
          doc.data, 
          doc.$id, // Pass the document's ID
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
        documentId: serviceCenter.id, // Let Appwrite generate a unique ID
        data: {
          'id': serviceCenter.id,
          'name': serviceCenter.name,
          'contactNumber': serviceCenter.contactNumber,
          'address': serviceCenter.address,
        },
      );

      // Add the newly created service center with ID
      _serviceCenters.add(ServiceCenterModel.fromMap(
        response.data,
        response.$id, // Use the response's $id
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
      await databases.updateDocument(
        databaseId: databaseId,
        collectionId: collectionId,
        documentId: serviceCenter.id, // Use the service center ID to update
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
        documentId: serviceCenter.id, // Use the service center ID
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

  // Fetch multiple service centers by their IDs
  Future<List<ServiceCenterModel>> getServiceCentersByIds(List<String> ids) async {
    try {
      List<ServiceCenterModel> fetchedServiceCenters = [];

      // Fetch each service center document by ID
      for (String id in ids) {
        final response = await Databases(_appwriteService.client).getDocument(
          databaseId: databaseId,
          collectionId: collectionId,
          documentId: id,
        );
        fetchedServiceCenters.add(ServiceCenterModel.fromMap(response.data, response.$id)); // Map document to ServiceCenterModel
      }

      return fetchedServiceCenters;
    } catch (e) {
      debugPrint('Error fetching service centers by IDs: $e');
      throw Exception('Failed to fetch service centers by IDs.');
    }
  }
}
