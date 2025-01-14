import 'package:em_repairs/services/apwrite_service.dart';
import 'package:flutter/foundation.dart';
import 'package:appwrite/appwrite.dart';
import 'package:em_repairs/models/order_model.dart'; // Import OrderModel

class OrderProvider with ChangeNotifier {
  final AppwriteService _appwriteService;
  late Databases _databases;

  // Database and Collection IDs
  final String _databaseId = '678241a4000c5def62aa'; // Replace with your actual database ID
  final String _collectionId = '6784e7110008b9ece183'; // Replace with your actual collection ID

  OrderProvider(this._appwriteService) {
    _databases = Databases(_appwriteService.client);
  }

  // List of OrderModel
  List<OrderModel> _orderList = [];
  List<OrderModel> get orderList => _orderList;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Save OrderModel Data to Appwrite
  Future<void> saveOrder(OrderModel model) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _databases.createDocument(
        databaseId: _databaseId,
        collectionId: _collectionId,
        documentId: model.id, // Appwrite will generate a unique ID
        data: model.toMap(),
      );

      // Create a new model with the returned ID and add it to the list
      final savedOrder = OrderModel.fromMap(response.data);
      _orderList.add(savedOrder);
      notifyListeners();
    } catch (e) {
      debugPrint('Error saving order: $e');
      throw Exception('Failed to save order data.');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Retrieve a single OrderModel by ID
  Future<OrderModel> getOrder(String documentId) async {
    try {
      final response = await _databases.getDocument(
        databaseId: _databaseId,
        collectionId: _collectionId,
        documentId: documentId,
      );
      return OrderModel.fromMap(response.data); // Create model from map
    } catch (e) {
      debugPrint('Error fetching order: $e');
      throw Exception('Failed to fetch order data.');
    }
  }

  // List All Orders
  Future<void> listOrders() async {
    _isLoading = true;
    notifyListeners();

    try {
      final result = await _databases.listDocuments(
        databaseId: _databaseId,
        collectionId: _collectionId,
      );

      _orderList = result.documents.map((doc) {
        return OrderModel.fromMap(doc.data); // Map document data to OrderModel
      }).toList();

      notifyListeners();
    } catch (e) {
      debugPrint('Error listing orders: $e');
      throw Exception('Failed to list order data.');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Update OrderModel Data
  Future<void> updateOrder(String documentId, OrderModel model) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _databases.updateDocument(
        databaseId: _databaseId,
        collectionId: _collectionId,
        documentId: documentId,
        data: model.toMap(),
      );

      // Update the order in the local list
      final index = _orderList.indexWhere((order) => order.id == documentId);
      if (index != -1) {
        _orderList[index] = model.copyWith(id: documentId); // Ensure ID consistency
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error updating order: $e');
      throw Exception('Failed to update order data.');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Delete OrderModel Data by ID
  Future<void> deleteOrder(String documentId) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _databases.deleteDocument(
        databaseId: _databaseId,
        collectionId: _collectionId,
        documentId: documentId,
      );

      // Remove the deleted order from the list
      _orderList.removeWhere((order) => order.id == documentId); // Use 'id' now
      notifyListeners();
    } catch (e) {
      debugPrint('Error deleting order: $e');
      throw Exception('Failed to delete order data.');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Fetch multiple orders by their IDs
  // Fetch a single OrderModel by its id
  Future<OrderModel> getOrderById(String id) async {
    try {
      final response = await _databases.getDocument(
        databaseId: _databaseId,
        collectionId: _collectionId,
        documentId: id,
      );

      return OrderModel.fromMap(response.data); // Map document data to OrderModel
    } catch (e) {
      debugPrint('Error fetching order by ID: $e');
      throw Exception('Failed to fetch order by ID.');
    }
  }
}
