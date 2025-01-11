import 'package:em_repairs/models/OrderModel.dart';
import 'package:flutter/foundation.dart';
import 'package:appwrite/appwrite.dart';
 // Import OrderModel
import 'package:em_repairs/services/appwrite_service.dart'; // Import AppwriteService

class OrderProvider with ChangeNotifier {
  final AppwriteService _appwriteService;
  late Databases _databases;

  // Database and Collection IDs
  final String _databaseId = '677fcede0019b442b2e7'; // Replace with your actual database ID
  final String _collectionId = '6781b306001904abdfe1'; // Replace with your actual collection ID

  OrderProvider(this._appwriteService) {
    _databases = Databases(_appwriteService.client);
  }

  // List to store orders
  List<OrderModel> _orders = [];
  List<OrderModel> get orders => _orders;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Fetch all orders from Appwrite
  Future<void> fetchOrders() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _databases.listDocuments(
        databaseId: _databaseId,
        collectionId: _collectionId,
      );
      _orders = response.documents
          .map((doc) => OrderModel.fromMap(doc.data, doc.$id))
          .toList();
      notifyListeners();
    } catch (e) {
      debugPrint('Error fetching orders: $e');
      throw Exception('Failed to fetch orders data.');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Add a new order to Appwrite
  Future<void> addOrder(OrderModel order) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _databases.createDocument(
        databaseId: _databaseId,
        collectionId: _collectionId,
        documentId: ID.unique(), // Appwrite will generate a unique ID
        data: order.toMap(),
      );
      final newOrder = OrderModel.fromMap(response.data, response.$id);
      _orders.add(newOrder); // Add the newly created order to the list
      notifyListeners();
    } catch (e) {
      debugPrint('Error adding order: $e');
      throw Exception('Failed to add order data.');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Retrieve a single order by ID
  Future<OrderModel> getOrder(String orderId) async {
    try {
      final response = await _databases.getDocument(
        databaseId: _databaseId,
        collectionId: _collectionId,
        documentId: orderId,
      );
      return OrderModel.fromMap(response.data, response.$id);
    } catch (e) {
      debugPrint('Error fetching order: $e');
      throw Exception('Failed to fetch order data.');
    }
  }

  // Update an existing order in Appwrite
  Future<void> updateOrder(String orderId, OrderModel order) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _databases.updateDocument(
        databaseId: _databaseId,
        collectionId: _collectionId,
        documentId: orderId,
        data: order.toMap(),
      );

      // Update the order in the local list
      final index = _orders.indexWhere((existingOrder) => existingOrder.id == orderId);
      if (index != -1) {
        _orders[index] = order;
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

  // Delete an order by ID
  Future<void> deleteOrder(String orderId) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _databases.deleteDocument(
        databaseId: _databaseId,
        collectionId: _collectionId,
        documentId: orderId,
      );

      // Remove the deleted order from the list
      _orders.removeWhere((order) => order.id == orderId);
      notifyListeners();
    } catch (e) {
      debugPrint('Error deleting order: $e');
      throw Exception('Failed to delete order data.');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
