import 'package:appwrite/appwrite.dart';
import 'package:em_repairs/models/order_details_models.dart';
import 'package:em_repairs/services/apwrite_service.dart';
import 'package:flutter/material.dart';

class OrderDetailsProvider extends ChangeNotifier {
  final AppwriteService _appwriteService;
  final List<OrderDetailsModel> _orders = [];
  OrderDetailsModel? _selectedOrder;

  static const String databaseId = '678241a4000c5def62aa'; // Replace with your database ID
  static const String collectionId = '6782c5a700139f0c96f5'; // Replace with your collection ID

  OrderDetailsProvider(this._appwriteService);

  // Getter for orders
  List<OrderDetailsModel> get orders => _orders;

  // Getter for selected order
  OrderDetailsModel? get selectedOrder => _selectedOrder;

  // Fetch orders from Appwrite
  Future<void> fetchOrders() async {
    try {
      final databases = Databases(_appwriteService.client);
      final response = await databases.listDocuments(
        databaseId: databaseId,
        collectionId: collectionId,
      );

      _orders.clear();
      for (var doc in response.documents) {
        _orders.add(OrderDetailsModel.fromMap(doc.data, doc.$id));
      }
      notifyListeners();
    } catch (e) {
      debugPrint('Error fetching orders: $e');
    }
  }

  // Add an order to Appwrite and the list
  Future<void> addOrder(OrderDetailsModel order) async {
    try {
      final databases = Databases(_appwriteService.client);
      final response = await databases.createDocument(
        databaseId: databaseId,
        collectionId: collectionId,
        documentId: 'unique()', // Let Appwrite generate a unique ID
        data: order.toMap(),
      );

      // Create the order model using the generated ID
      _orders.add(OrderDetailsModel.fromMap(response.data, response.$id));
      notifyListeners();
    } catch (e) {
      debugPrint('Error adding order: $e');
    }
  }

  // Update an existing order in Appwrite and the list
  Future<void> updateOrder(OrderDetailsModel order) async {
    try {
      final databases = Databases(_appwriteService.client);
      await databases.updateDocument(
        databaseId: databaseId,
        collectionId: collectionId,
        documentId: order.id!, // 'id' is required now, assert it's non-null
        data: order.toMap(),
      );

      final index = _orders.indexWhere((o) => o.id == order.id);
      if (index != -1) {
        _orders[index] = order;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error updating order: $e');
    }
  }

  // Remove an order from Appwrite and the list
  Future<void> removeOrder(OrderDetailsModel order) async {
    try {
      final databases = Databases(_appwriteService.client);
      await databases.deleteDocument(
        databaseId: databaseId,
        collectionId: collectionId,
        documentId: order.id!, // 'id' is required now, assert it's non-null
      );

      _orders.remove(order);
      notifyListeners();
    } catch (e) {
      debugPrint('Error removing order: $e');
    }
  }

  // Select an order
  void selectOrder(OrderDetailsModel order) {
    _selectedOrder = order;
    notifyListeners();
  }

  // Remove selected order
  void removeSelectedOrder() {
    _selectedOrder = null;
    notifyListeners();
  }

  // Search orders locally by device model or other fields
  List<OrderDetailsModel> searchOrders(String query) {
    return _orders.where((order) {
      final deviceModel = order.deviceModel.toLowerCase();
      return deviceModel.contains(query.toLowerCase());
    }).toList();
  }

  // Fetch a single order detail by its ID
  Future<OrderDetailsModel> getOrderDetailById(String id) async {
    try {
      final response = await Databases(_appwriteService.client).getDocument(
        databaseId: databaseId,
        collectionId: collectionId,
        documentId: id,
      );

      return OrderDetailsModel.fromMap(
        response.toMap(), response.$id, // Ensure ID is passed
      );
    } catch (e) {
      debugPrint('Error fetching order detail by ID: $e');
      throw Exception('Failed to fetch order detail by ID.');
    }
  }
}
