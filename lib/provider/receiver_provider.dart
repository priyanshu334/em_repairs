import 'package:appwrite/appwrite.dart';
import 'package:em_repairs/models/receiver_model.dart';
import 'package:flutter/material.dart';
import 'package:em_repairs/services/appwrite_service.dart';

class ReceiverDetailsProvider extends ChangeNotifier {
  final AppwriteService _appwriteService;
  final List<ReceiverDetailsModel> _receivers = [];
  ReceiverDetailsModel? _selectedReceiver;

  static const String databaseId = '677fcede0019b442b2e7'; // Replace with your actual database ID
  static const String collectionId = '677fd1db00220b67040f'; // Replace with your actual collection ID

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
        _receivers.add(ReceiverDetailsModel(
          id: doc.$id,
          name: doc.data['name'],
          isOwner: doc.data['isOwner'],
          isStaff: doc.data['isStaff'],
        ));
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
        documentId: 'unique()', // Let Appwrite generate a unique ID
        data: {
          'name': receiver.name,
          'isOwner': receiver.isOwner,
          'isStaff': receiver.isStaff,
        },
      );

      _receivers.add(ReceiverDetailsModel(
        id: response.$id,
        name: receiver.name,
        isOwner: receiver.isOwner,
        isStaff: receiver.isStaff,
      ));
      notifyListeners();
    } catch (e) {
      debugPrint('Error adding receiver details: $e');
    }
  }

  // Remove a receiver from Appwrite and the list
  Future<void> removeReceiver(ReceiverDetailsModel receiver) async {
    try {
      final databases = Databases(_appwriteService.client);
      await databases.deleteDocument(
        databaseId: databaseId,
        collectionId: collectionId,
        documentId: receiver.id!,
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
}
