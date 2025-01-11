import 'package:appwrite/appwrite.dart';
import 'package:em_repairs/models/customer_model.dart';
import 'package:em_repairs/services/appwrite_service.dart';
import 'package:flutter/foundation.dart';

class CustomerProvider extends ChangeNotifier {
  final AppwriteService _appwriteService;
  final List<CustomerModel> _customers = [];
  CustomerModel? _selectedCustomer;

  static const String databaseId = '677fcede0019b442b2e7';
  static const String collectionId = '677fcfae001d29ddc187';

  CustomerProvider(this._appwriteService);

  // Getter for customers
  List<CustomerModel> get customers => _customers;

  // Getter for the selected customer
  CustomerModel? get selectedCustomer => _selectedCustomer;

  // Fetch customers from Appwrite
  Future<void> fetchCustomers() async {
    try {
      final databases = Databases(_appwriteService.client);
      final response = await databases.listDocuments(
        databaseId: databaseId,
        collectionId: collectionId,
      );

      _customers.clear();
      for (var doc in response.documents) {
        // Use fromMap to create CustomerModel instances
        _customers.add(CustomerModel.fromMap(
          doc.data,  // Document data
          doc.$id,   // Document ID
        ));
      }
      notifyListeners();
    } catch (e) {
      debugPrint('Error fetching customers: $e');
    }
  }

  // Add a customer to Appwrite and the list
  Future<void> addCustomer(CustomerModel customer) async {
    try {
      final databases = Databases(_appwriteService.client);
      final response = await databases.createDocument(
        databaseId: databaseId,
        collectionId: collectionId,
        documentId: 'unique()', // Let Appwrite generate a unique ID
        data: customer.toMap(), // Use toMap to convert CustomerModel to Map
      );

      // Add the customer with the newly generated ID
      _customers.add(CustomerModel(
        id: response.$id,  // Use the ID from Appwrite response
        name: customer.name,
        phone: customer.phone,
        address: customer.address,
      ));
      notifyListeners();
    } catch (e) {
      debugPrint('Error adding customer: $e');
    }
  }

  // Remove a customer from Appwrite and the list
  Future<void> removeCustomer(CustomerModel customer) async {
    try {
      final databases = Databases(_appwriteService.client);
      await databases.deleteDocument(
        databaseId: databaseId,
        collectionId: collectionId,
        documentId: customer.id!,
      );

      _customers.remove(customer);
      notifyListeners();
    } catch (e) {
      debugPrint('Error removing customer: $e');
    }
  }

  // Select a customer
  void selectCustomer(CustomerModel customer) {
    _selectedCustomer = customer;
    notifyListeners();
  }

  // Remove selected customer
  void removeSelectedCustomer() {
    _selectedCustomer = null;
    notifyListeners();
  }

  // Search customers locally
  List<CustomerModel> searchCustomers(String query) {
    return _customers
        .where((customer) =>
            customer.name.toLowerCase().contains(query.toLowerCase()) ||
            customer.phone.contains(query))
        .toList();
  }
}
