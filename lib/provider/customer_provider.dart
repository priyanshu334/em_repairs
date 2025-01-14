import 'package:appwrite/appwrite.dart';
import 'package:em_repairs/services/apwrite_service.dart';
import 'package:flutter/foundation.dart';
import '../models/customer_model.dart';

class CustomerProvider extends ChangeNotifier {
  final AppwriteService _appwriteService;
  final List<CustomerModel> _customers = [];
  CustomerModel? _selectedCustomer;

  static const String databaseId = '678241a4000c5def62aa';
  static const String collectionId = '6782c3aa001ca42514fe';

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
        _customers.add(CustomerModel.fromMap(doc.data, documentId: doc.$id)); // Pass document ID
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
        documentId: customer.id ?? '', // Appwrite will generate the ID if it's null
        data: customer.toMap(),
      );

      // Fetch the document and update the list with new ID
      final addedCustomer = CustomerModel.fromMap(response.data, documentId: response.$id);
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
        documentId: customer.id!,
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
        documentId: customer.id!,
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

      return CustomerModel.fromMap(response.data, documentId: response.$id);
    } catch (e) {
      debugPrint('Error fetching customer by ID: ${e.toString()}');
      return null; // Return null if the document does not exist or there's an error
    }
  }
}
