import 'package:appwrite/appwrite.dart';
import 'package:em_repairs/services/apwrite_service.dart';
import 'package:flutter/foundation.dart';
import '../models/customer_model.dart';

class CustomerProvider extends ChangeNotifier {
  final AppwriteService _appwriteService;
  final List<CustomerModel> _customers = [];
  CustomerModel? _selectedCustomer;

  static const String databaseId = '678690d10024689b7151';
  static const String collectionId = '678691f300189eff0ac8';

  CustomerProvider(this._appwriteService);

  // Getter for customers
  List<CustomerModel> get customers => _customers;

  // Getter for selected customer
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
      for (var doc in response.documents ?? []) {
        _customers.add(CustomerModel.fromMap(doc.data)); // Removed documentId
      }
      notifyListeners();
      debugPrint('Fetched ${_customers.length} customers successfully.');
    } catch (e) {
      debugPrint('Error fetching customers: ${e.toString()}');
    }
  }

  // Add a customer
  Future<void> addCustomer(CustomerModel customer) async {
    try {
      final databases = Databases(_appwriteService.client);
      final response = await databases.createDocument(
        databaseId: databaseId,
        collectionId: collectionId,
        documentId: ID.unique(), // Let Appwrite generate the ID
        data: customer.toMap(),
      );

      // Fetch the document and update the list
      final addedCustomer = CustomerModel.fromMap(response.data,documentId: response.$id); // Removed documentId
      _customers.add(addedCustomer);
      notifyListeners();
      debugPrint('Customer added: ${customer.name}');
    } catch (e) {
      debugPrint('Error adding customer: ${e.toString()}');
    }
  }

  // Update a customer
  Future<void> updateCustomer(CustomerModel customer) async {
    try {
      final databases = Databases(_appwriteService.client);
      await databases.updateDocument(
        databaseId: databaseId,
        collectionId: collectionId,
        documentId: customer.id!, // You can keep this if required but ensure customer has an ID
        data: customer.toMap(),
      );

      final index = _customers.indexWhere((c) => c.id == customer.id);
      if (index != -1) {
        _customers[index] = customer;
        notifyListeners();
      }
      debugPrint('Customer updated: ${customer.name}');
    } catch (e) {
      debugPrint('Error updating customer: ${e.toString()}');
    }
  }

  // Delete a customer
  Future<void> removeCustomer(CustomerModel customer) async {
    try {
      final databases = Databases(_appwriteService.client);
      await databases.deleteDocument(
        databaseId: databaseId,
        collectionId: collectionId,
        documentId: customer.id!, // Ensure customer has an ID before deletion
      );

      _customers.removeWhere((c) => c.id == customer.id);
      notifyListeners();
      debugPrint('Customer removed: ${customer.name}');
    } catch (e) {
      debugPrint('Error removing customer: ${e.toString()}');
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
    return _customers.where((customer) {
      return customer.name.toLowerCase().contains(query.toLowerCase()) ||
          customer.phone.contains(query);
    }).toList();
  }

  // Fetch a customer by ID
  Future<CustomerModel?> fetchCustomerById(String id) async {
    try {
      final databases = Databases(_appwriteService.client);
      final response = await databases.getDocument(
        databaseId: databaseId,
        collectionId: collectionId,
        documentId: id,
      );

      return CustomerModel.fromMap(response.data); // Removed documentId
    } catch (e) {
      debugPrint('Error fetching customer by ID: ${e.toString()}');
      return null;
    }
  }
}
