import 'package:appwrite/appwrite.dart';
import 'package:em_repairs/models/service_provider_model.dart';
import 'package:em_repairs/services/appwrite_service.dart';
import 'package:flutter/material.dart';

class ServiceProviderProvider extends ChangeNotifier {
  final AppwriteService _appwriteService;
  final List<ServiceProviderModel> _serviceProviders = [];
  ServiceProviderModel? _selectedServiceProvider;

  static const String databaseId = '677fcede0019b442b2e7'; // Replace with your actual database ID
  static const String collectionId = '6780fe6800149a7c2228'; // Replace with your actual collection ID

  ServiceProviderProvider(this._appwriteService);

  // Getter for service providers
  List<ServiceProviderModel> get serviceProviders => _serviceProviders;

  // Getter for the selected service provider
  ServiceProviderModel? get selectedServiceProvider => _selectedServiceProvider;

  // Fetch service providers from Appwrite
  Future<void> fetchServiceProviders() async {
    try {
      final databases = Databases(_appwriteService.client);
      final response = await databases.listDocuments(
        databaseId: databaseId, 
        collectionId: collectionId,
      );

      _serviceProviders.clear();
      for (var doc in response.documents) {
        _serviceProviders.add(ServiceProviderModel.fromMap(
          doc.data,
          doc.$id,
        ));
      }
      notifyListeners();
    } catch (e) {
      debugPrint('Error fetching service providers: $e');
    }
  }

  // Add a service provider to Appwrite and the list
  Future<void> addServiceProvider(ServiceProviderModel serviceProvider) async {
    try {
      final databases = Databases(_appwriteService.client);
      final response = await databases.createDocument(
        databaseId: databaseId,
        collectionId: collectionId,
        documentId: 'unique()', // Let Appwrite generate a unique ID
        data: serviceProvider.toMap(),
      );

      _serviceProviders.add(ServiceProviderModel.fromMap(
        response.data,
        response.$id,
      ));
      notifyListeners();
    } catch (e) {
      debugPrint('Error adding service provider: $e');
    }
  }

  // Update a service provider in Appwrite and the list
  Future<void> updateServiceProvider(ServiceProviderModel serviceProvider) async {
    try {
      final databases = Databases(_appwriteService.client);
      await databases.updateDocument(
        databaseId: databaseId,
        collectionId: collectionId,
        documentId: serviceProvider.id!,
        data: serviceProvider.toMap(),
      );

      final index = _serviceProviders.indexWhere((sp) => sp.id == serviceProvider.id);
      if (index != -1) {
        _serviceProviders[index] = serviceProvider;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error updating service provider: $e');
    }
  }

  // Remove a service provider from Appwrite and the list
  Future<void> removeServiceProvider(ServiceProviderModel serviceProvider) async {
    try {
      final databases = Databases(_appwriteService.client);
      await databases.deleteDocument(
        databaseId: databaseId,
        collectionId: collectionId,
        documentId: serviceProvider.id!,
      );

      _serviceProviders.remove(serviceProvider);
      notifyListeners();
    } catch (e) {
      debugPrint('Error removing service provider: $e');
    }
  }

  // Select a service provider
  void selectServiceProvider(ServiceProviderModel serviceProvider) {
    _selectedServiceProvider = serviceProvider;
    notifyListeners();
  }

  // Remove the selected service provider
  void removeSelectedServiceProvider() {
    _selectedServiceProvider = null;
    notifyListeners();
  }

  // Search service providers locally
  List<ServiceProviderModel> searchServiceProviders(String query) {
    return _serviceProviders
        .where((provider) =>
            provider.name.toLowerCase().contains(query.toLowerCase()) ||
            provider.contactNo.toLowerCase().contains(query.toLowerCase()) ||
            provider.description.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }
}
