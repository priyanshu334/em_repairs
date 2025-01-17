import 'package:appwrite/appwrite.dart';
import 'package:em_repairs/models/repair_partner_detail.dart';
import 'package:em_repairs/services/apwrite_service.dart';
import 'package:flutter/material.dart';

class RepairPartnerDetailsProvider extends ChangeNotifier {
  final AppwriteService _appwriteService;
  final List<RepairPartnerDetailsModel> _repairPartnerDetailsList = [];
  RepairPartnerDetailsModel? _selectedRepairPartnerDetails;

  static const String databaseId = '678690d10024689b7151';
  static const String collectionId = '67869633001729c68a68';

  RepairPartnerDetailsProvider(this._appwriteService);

  // Getter for the list of repair partner details
  List<RepairPartnerDetailsModel> get repairPartnerDetailsList =>
      _repairPartnerDetailsList;

  // Getter for the selected repair partner details
  RepairPartnerDetailsModel? get selectedRepairPartnerDetails =>
      _selectedRepairPartnerDetails;

  // Fetch repair partner details from Appwrite
  Future<void> fetchRepairPartnerDetails() async {
    try {
      final databases = Databases(_appwriteService.client);
      final response = await databases.listDocuments(
        databaseId: databaseId,
        collectionId: collectionId,
      );

      _repairPartnerDetailsList.clear();
      for (var doc in response.documents) {
        _repairPartnerDetailsList.add(
          RepairPartnerDetailsModel.fromMap(
            doc.data,
            documentId: doc.$id, // Use Appwrite document ID as the id
          ),
        );
      }
      notifyListeners();
    } catch (e) {
      debugPrint('Error fetching repair partner details: $e');
    }
  }

  // Add a repair partner detail to Appwrite and the list
  Future<void> addRepairPartnerDetails(
      RepairPartnerDetailsModel details) async {
    try {
      final databases = Databases(_appwriteService.client);
      final response = await databases.createDocument(
        databaseId: databaseId,
        collectionId: collectionId,
        documentId: details.id, // Use the id from details
        data: details.toMap(),
      );

      _repairPartnerDetailsList.add(
        RepairPartnerDetailsModel.fromMap(
          response.data,
          documentId: response.$id, // Use the generated ID from Appwrite
        ),
      );
      notifyListeners();
    } catch (e) {
      debugPrint('Error adding repair partner details: $e');
    }
  }

  // Update an existing repair partner detail in Appwrite and the list
  Future<void> updateRepairPartnerDetails(
      RepairPartnerDetailsModel details) async {
    try {
      if (details.id.isEmpty) {
        throw Exception('Cannot update a repair partner detail without an ID.');
      }

      final databases = Databases(_appwriteService.client);
      await databases.updateDocument(
        databaseId: databaseId,
        collectionId: collectionId,
        documentId: details.id,
        data: details.toMap(),
      );

      final index =
          _repairPartnerDetailsList.indexWhere((e) => e.id == details.id);
      if (index != -1) {
        _repairPartnerDetailsList[index] = details;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error updating repair partner details: $e');
    }
  }

  // Remove a repair partner detail from Appwrite and the list
  Future<void> removeRepairPartnerDetails(
      RepairPartnerDetailsModel details) async {
    try {
      if (details.id.isEmpty) {
        throw Exception('Cannot remove a repair partner detail without an ID.');
      }

      final databases = Databases(_appwriteService.client);
      await databases.deleteDocument(
        databaseId: databaseId,
        collectionId: collectionId,
        documentId: details.id,
      );

      _repairPartnerDetailsList.remove(details);
      notifyListeners();
    } catch (e) {
      debugPrint('Error removing repair partner details: $e');
    }
  }

  // Select a repair partner detail
  void selectRepairPartnerDetails(RepairPartnerDetailsModel details) {
    _selectedRepairPartnerDetails = details;
    notifyListeners();
  }

  // Remove selected repair partner detail
  void removeSelectedRepairPartnerDetails() {
    _selectedRepairPartnerDetails = null;
    notifyListeners();
  }

  // Search repair partner details locally by selected operator or service center
  List<RepairPartnerDetailsModel> searchRepairPartnerDetails(String query) {
    return _repairPartnerDetailsList.where((details) {
      final operatorString = details.selectedOperator ?? '';
      final serviceCenterString = details.selectedServiceCenter ?? '';
      return operatorString.contains(query) ||
          serviceCenterString.contains(query);
    }).toList();
  }

  // Fetch a single RepairPartnerDetailsModel by its ID
  Future<RepairPartnerDetailsModel> getRepairPartnerDetailById(
      String id) async {
    try {
      final response = await Databases(_appwriteService.client).getDocument(
        databaseId: databaseId,
        collectionId: collectionId,
        documentId: id,
      );

      return RepairPartnerDetailsModel.fromMap(response.data, documentId: response.$id);
    } catch (e) {
      debugPrint('Error fetching repair partner detail by ID: $e');
      throw Exception('Failed to fetch repair partner detail by ID.');
    }
  }
}
