  import 'package:em_repairs/models/Order_model.dart';
  import 'package:em_repairs/services/apwrite_service.dart';
  import 'package:flutter/foundation.dart';
  import 'package:appwrite/appwrite.dart';

  class OrderProvider with ChangeNotifier {
    final AppwriteService _appwriteService;
    late Databases _databases;

    // Database and Collection IDs
    final String _databaseId = '678690d10024689b7151'; // Replace with your actual database ID
    final String _collectionId = '6787938d0029b60ce7b9'; // Replace with your actual collection ID

    OrderProvider(this._appwriteService) {
      _databases = Databases(_appwriteService.client);
    }

    // List of OrderModel
    List<OrderModel> _orderList = [];
    List<OrderModel> get orderList => _orderList;

    int _loadingCounter = 0;
    bool get isLoading => _loadingCounter > 0;

    void _incrementLoading() {
      _loadingCounter++;
      notifyListeners();
    }

    void _decrementLoading() {
      _loadingCounter--;
      if (_loadingCounter < 0) _loadingCounter = 0;
      notifyListeners();
    }

    // Save OrderModel Data to Appwrite
    Future<void> saveOrder(OrderModel model) async {
      _incrementLoading();
      try {
        final response = await _databases.createDocument(
          databaseId: _databaseId,
          collectionId: _collectionId,
          documentId: ID.unique(),
          data: model.toMap(),
        );

        final savedOrder = OrderModel.fromMap(response.data, documentId: response.$id);
        _orderList.add(savedOrder);
        notifyListeners();
      } catch (e) {
        debugPrint('Error saving order: $e');
        throw Exception('Failed to save order data.');
      } finally {
        _decrementLoading();
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

        return OrderModel.fromMap(response.data, documentId: response.$id);
      } catch (e) {
        debugPrint('Error fetching order: $e');
        throw Exception('Failed to fetch order data.');
      }
    }

    // Retrieve a single OrderModel by ID with local cache optimization
    Future<OrderModel> getOrderById(String documentId) async {
      try {
        final localOrder = _orderList.firstWhere(
          (order) => order.id == documentId,
        );

        if (localOrder != null) {
          return localOrder;
        }
      } catch (e) {
        debugPrint('Order not found in local cache: $e');
      }

      try {
        final response = await _databases.getDocument(
          databaseId: _databaseId,
          collectionId: _collectionId,
          documentId: documentId,
        );

        final fetchedOrder = OrderModel.fromMap(response.data, documentId: response.$id);
        _orderList.add(fetchedOrder);
        notifyListeners();

        return fetchedOrder;
      } catch (e) {
        debugPrint('Error fetching order by ID: $e');
        throw Exception('Failed to fetch order by ID.');
      }
    }

    // List All Orders with Pagination
    Future<void> listOrders({int limit = 25, int offset = 0}) async {
      _incrementLoading();
      try {
        final result = await _databases.listDocuments(
          databaseId: _databaseId,
          collectionId: _collectionId,
          queries: [
            Query.limit(limit),
            Query.offset(offset),
          ],
        );

        if (result.documents.isEmpty) {
          debugPrint('No orders found.');
        }

        _orderList = result.documents.map((doc) {
          if (doc.data == null) {
            debugPrint('Empty document data: ${doc.$id}');
            return null;
          }
          return OrderModel.fromMap(doc.data, documentId: doc.$id);
        }).where((order) => order != null).cast<OrderModel>().toList();

        notifyListeners();
      } catch (e) {
        debugPrint('Error listing orders: $e');
        throw Exception('Failed to list order data.');
      } finally {
        _decrementLoading();
      }
    }

    // List Orders by Customer ID


    // Update OrderModel Data
    Future<void> updateOrder(String documentId, OrderModel model) async {
      _incrementLoading();
      try {
        await _databases.updateDocument(
          databaseId: _databaseId,
          collectionId: _collectionId,
          documentId: documentId,
          data: model.toMap(),
        );

        final index = _orderList.indexWhere((order) => order.id == documentId);
        if (index != -1) {
          _orderList[index] = model.copyWith(id: documentId);
          notifyListeners();
        }
      } catch (e) {
        debugPrint('Error updating order: $e');
        throw Exception('Failed to update order data.');
      } finally {
        _decrementLoading();
      }
    }

    // Delete OrderModel Data by ID
    Future<void> deleteOrder(String documentId) async {
      _incrementLoading();
      try {
        await _databases.deleteDocument(
          databaseId: _databaseId,
          collectionId: _collectionId,
          documentId: documentId,
        );

        _orderList.removeWhere((order) => order.id == documentId);
        notifyListeners();
      } catch (e) {
        debugPrint('Error deleting order: $e');
        throw Exception('Failed to delete order data.');
      } finally {
        _decrementLoading();
      }
    }

    Future<void> listOrdersByCustomer(String customerName) async {
    _incrementLoading();
    try {
      final result = await _databases.listDocuments(
        databaseId: _databaseId,
        collectionId: _collectionId,
        queries: [
          Query.search('customerModel.name', customerName), // Adjust to match the schema
        ],
      );

      _orderList = result.documents.map((doc) {
        if (doc.data == null) {
          debugPrint('Empty document data: ${doc.$id}');
          return null;
        }
        return OrderModel.fromMap(doc.data, documentId: doc.$id);
      }).where((order) => order != null).cast<OrderModel>().toList();

      notifyListeners();
    } catch (e) {
      debugPrint('Error listing orders by customer: $e');
      throw Exception('Failed to list orders by customer.');
    } finally {
      _decrementLoading();
    }
  }

  }
  