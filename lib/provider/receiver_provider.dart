import 'package:appwrite/appwrite.dart';
import 'package:em_repairs/models/receiver_model.dart';
import 'package:em_repairs/services/apwrite_service.dart';
import 'package:flutter/material.dart';

class ReceiverDetailsProvider extends ChangeNotifier {
  final AppwriteService _appwriteService;
  final List<ReceiverDetailsModel> _receivers = [];
  ReceiverDetailsModel? _selectedReceiver;

  static const String databaseId = '678241a4000c5def62aa'; // Replace with your actual database ID
  static const String collectionId = '6782c62d003283a3990f'; // Replace with your actual collection ID

  ReceiverDetailsProvider(this._appwriteService);

  // Getter for receiver details
  List<ReceiverDetailsModel> get receivers => _receivers;

  // Getter for selected receiver
  ReceiverDetailsModel? get selectedReceiver => _selectedReceiver;

  // Fetch receiver details from Appwrite
  Future<void> fetchReceivers() async {
    try {
      final databases = Databases(_appwriteService.client);
      final response = await databases.listDocuments(
        databaseId: databaseId,
        collectionId: collectionId,
      );

      _receivers.clear();
      for (var doc in response.documents) {
        _receivers.add(ReceiverDetailsModel.fromMap(doc.data)); // No `doc.$id`
      }
      notifyListeners();
    } catch (e) {
      debugPrint('Error fetching receiver details: $e');
    }
  }

  // Add a receiver to Appwrite and the list
  Future<void> addReceiver(ReceiverDetailsModel receiver) async {
    try {
      final databases = Databases(_appwriteService.client);
      final response = await databases.createDocument(
        databaseId: databaseId,
        collectionId: collectionId,
        documentId: receiver.id ?? 'unique()', // Let Appwrite generate an ID
        data: {
          'name': receiver.name,
          'isOwner': receiver.isOwner,
          'isStaff': receiver.isStaff,
        },
      );

      // Add the receiver to the list
      _receivers.add(ReceiverDetailsModel.fromMap(response.data)); // No `response.$id`
      notifyListeners();
    } catch (e) {
      debugPrint('Error adding receiver details: $e');
    }
  }

  // Remove a receiver from Appwrite and the list
  Future<void> removeReceiver(ReceiverDetailsModel receiver) async {
    try {
      final databases = Databases(_appwriteService.client);
      if (receiver.id == null) {
        throw Exception('Cannot remove a receiver without an ID.');
      }
      await databases.deleteDocument(
        databaseId: databaseId,
        collectionId: collectionId,
        documentId: receiver.id!, // Use the receiver's ID
      );

      _receivers.remove(receiver);
      notifyListeners();
    } catch (e) {
      debugPrint('Error removing receiver details: $e');
    }
  }

  // Select a receiver
  void selectReceiver(ReceiverDetailsModel receiver) {
    _selectedReceiver = receiver;
    notifyListeners();
  }

  // Remove selected receiver
  void removeSelectedReceiver() {
    _selectedReceiver = null;
    notifyListeners();
  }

  // Search receivers locally by name
  List<ReceiverDetailsModel> searchReceivers(String query) {
    return _receivers
        .where((receiver) =>
            receiver.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  // Fetch a single ReceiverDetailsModel by its ID
  Future<ReceiverDetailsModel> getReceiverById(String id) async {
    try {
      final response = await Databases(_appwriteService.client).getDocument(
        databaseId: databaseId,
        collectionId: collectionId,
        documentId: id,
      );

      return ReceiverDetailsModel.fromMap(response.toMap()); // No `id` passed
    } catch (e) {
      debugPrint('Error fetching receiver by ID: $e');
      throw Exception('Failed to fetch receiver by ID.');
    }
  }
}
