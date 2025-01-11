import 'package:appwrite/appwrite.dart';
import 'package:em_repairs/models/repair_partner_detail.dart';
import 'package:em_repairs/services/appwrite_service.dart';
import 'package:flutter/material.dart';

class RepairPartnerDetailsProvider extends ChangeNotifier {
  final AppwriteService _appwriteService;
  final List<RepairPartnerDetailsModel> _repairPartnerDetailsList = [];
  RepairPartnerDetailsModel? _selectedRepairPartnerDetails;

  static const String databaseId = '677fcede0019b442b2e7'; // Replace with your actual database ID
  static const String collectionId = '67817eeb0015143df921'; // Replace with your actual collection ID

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
        _repairPartnerDetailsList.add(RepairPartnerDetailsModel.fromMap(doc.data));
      }
      notifyListeners();
    } catch (e) {
      debugPrint('Error fetching repair partner details: $e');
    }
  }

  // Add a repair partner detail to Appwrite and the list
  Future<void> addRepairPartnerDetails(RepairPartnerDetailsModel details) async {
    try {
      final databases = Databases(_appwriteService.client);
      final response = await databases.createDocument(
        databaseId: databaseId,
        collectionId: collectionId,
        documentId: 'unique()', // Let Appwrite generate a unique ID
        data: details.toMap(),
      );

      _repairPartnerDetailsList.add(RepairPartnerDetailsModel.fromMap(response.data));
      notifyListeners();
    } catch (e) {
      debugPrint('Error adding repair partner details: $e');
    }
  }

  // Update an existing repair partner detail in Appwrite and the list
  Future<void> updateRepairPartnerDetails(RepairPartnerDetailsModel details) async {
    try {
      final databases = Databases(_appwriteService.client);
      await databases.updateDocument(
        databaseId: databaseId,
        collectionId: collectionId,
        documentId: details.id!,
        data: details.toMap(),
      );

      final index = _repairPartnerDetailsList.indexWhere((e) => e.id == details.id);
      if (index != -1) {
        _repairPartnerDetailsList[index] = details;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error updating repair partner details: $e');
    }
  }

  // Remove a repair partner detail from Appwrite and the list
  Future<void> removeRepairPartnerDetails(RepairPartnerDetailsModel details) async {
    try {
      final databases = Databases(_appwriteService.client);
      await databases.deleteDocument(
        databaseId: databaseId,
        collectionId: collectionId,
        documentId: details.id!,
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
      return operatorString.contains(query) || serviceCenterString.contains(query);
    }).toList();
  }
}
