import 'package:flutter/material.dart';
import 'package:em_repairs/models/customer_model.dart';
import 'package:em_repairs/models/device_kyc_model.dart';
import 'package:em_repairs/models/estimate_form.dart';
import 'package:em_repairs/models/receiver_model.dart';
import 'package:em_repairs/models/repair_partner_detail.dart';

class OrderModel {
  final String id; // Make 'id' required
  final ReceiverDetailsModel receiverDetails;
  final CustomerModel customer;
  final EstimateModel estimate;
  final DeviceKycModel deviceKyc;
  final RepairPartnerDetailsModel repairPartnerDetails;

  OrderModel({
    required this.id, // 'id' is now required
    required this.receiverDetails,
    required this.customer,
    required this.estimate,
    required this.deviceKyc,
    required this.repairPartnerDetails,
  });

  // Convert the model to a map (for database operations)
  Map<String, dynamic> toMap() {
    return {
      'id': id, // Include 'id' in the map
      'receiverDetails': receiverDetails.toMap(),
      'customer': customer.toMap(),
      'estimate': estimate.toMap(),
      'deviceKyc': deviceKyc.toMap(),
      'repairPartnerDetails': repairPartnerDetails.toMap(),
    };
  }

  // Create a model from a map (useful for parsing database responses)
  factory OrderModel.fromMap(Map<String, dynamic> map, String documentId) {
    return OrderModel(
      id: documentId, // Use the document ID from the response
      receiverDetails: ReceiverDetailsModel.fromMap(map['receiverDetails']),
      customer: CustomerModel.fromMap(map['customer']),
      estimate: EstimateModel.fromMap(map['estimate']),
      deviceKyc: DeviceKycModel.fromMap(map['deviceKyc']),
      repairPartnerDetails: RepairPartnerDetailsModel.fromMap(map['repairPartnerDetails']),
    );
  }

  @override
  String toString() {
    return 'OrderModel(id: $id, receiverDetails: $receiverDetails, customer: $customer, estimate: $estimate, deviceKyc: $deviceKyc, repairPartnerDetails: $repairPartnerDetails)';
  }

  // CopyWith method for easier updates
  OrderModel copyWith({
    String? id,
    ReceiverDetailsModel? receiverDetails,
    CustomerModel? customer,
    EstimateModel? estimate,
    DeviceKycModel? deviceKyc,
    RepairPartnerDetailsModel? repairPartnerDetails,
  }) {
    return OrderModel(
      id: id ?? this.id,
      receiverDetails: receiverDetails ?? this.receiverDetails,
      customer: customer ?? this.customer,
      estimate: estimate ?? this.estimate,
      deviceKyc: deviceKyc ?? this.deviceKyc,
      repairPartnerDetails: repairPartnerDetails ?? this.repairPartnerDetails,
    );
  }
}
