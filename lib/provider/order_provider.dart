import 'package:em_repairs/models/Order_model.dart';
import 'package:em_repairs/services/apwrite_service.dart';
import 'package:flutter/foundation.dart';
import 'package:appwrite/appwrite.dart';

class OrderProvider with ChangeNotifier {
  final AppwriteService _appwriteService;
  late Databases _databases;

  // Database and Collection IDs
  final String _databaseId = '678690d10024689b7151'; // Replace with your actual database ID
  final String _collectionId = '6786a989001e0a3c5aa3'; // Replace with your actual collection ID

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
      // If ID is null, let Appwrite generate it
      final documentId = model.id ?? ''; // Let Appwrite generate the ID

      final response = await _databases.createDocument(
        databaseId: _databaseId,
        collectionId: _collectionId,
        documentId: documentId, // Use provided or generated document ID
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
      return OrderModel.fromMap(response.data); // Use document ID from response
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
        return OrderModel.fromMap(doc.data); // Pass document ID for mapping
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
      if (model.id != null) {
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
      } else {
        debugPrint('Error: Order ID is missing.');
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
}
