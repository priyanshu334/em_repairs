import 'package:em_repairs/models/DeviceKycModels.dart';
import 'package:em_repairs/models/customer_model.dart';
import 'package:em_repairs/models/device_kyc_model.dart';
import 'package:em_repairs/models/order_details_models.dart';
import 'package:em_repairs/models/receiver_model.dart';
import 'package:em_repairs/models/repair_partner_detail.dart';
import 'package:em_repairs/models/estimate_form.dart';
import 'package:flutter/material.dart';

class OrderModel {
  final String? id; // Make 'id' nullable
  final ReceiverDetailsModel receiverDetails;
  final CustomerModel customer;
  final OrderDetailsModel orderDetailsModel;
  final EstimateModel estimate;
  final DeviceKycModels? deviceKyc; // Make deviceKyc nullable
  final RepairPartnerDetailsModel repairPartnerDetails;

  OrderModel({
    this.id, // 'id' is now optional
    required this.receiverDetails,
    required this.customer,
    required this.orderDetailsModel,
    required this.estimate,
    this.deviceKyc, // Nullable DeviceKycModels
    required this.repairPartnerDetails,
  });

  // Convert the model to a map (for Appwrite database operations)
  Map<String, dynamic> toMap() {
    return {
     
      'receiverDetails': receiverDetails.toMap(),
      'customer': customer.toMap(),
      'orderDetailsModel': orderDetailsModel.toMap(),
      'estimate': estimate.toMap(),
      'deviceKyc': deviceKyc?.toMap(), // Handle nullable values
      'repairPartnerDetails': repairPartnerDetails.toMap(),
    };
  }

  // Create a model from a map (useful for parsing Appwrite responses)
  factory OrderModel.fromMap(Map<String, dynamic> map, {String? documentId}) {
    return OrderModel(
      id: documentId, // 'id' is now optional and can be null
      receiverDetails: ReceiverDetailsModel.fromMap(map['receiverDetails']),
      customer: CustomerModel.fromMap(map['customer']),
      orderDetailsModel: OrderDetailsModel.fromMap(map['orderDetailsModel']),
      estimate: EstimateModel.fromMap(map['estimate']),
      deviceKyc: map['deviceKyc'] != null ? DeviceKycModels.fromMap(map['deviceKyc']) : null, // Handle nullable deviceKyc
      repairPartnerDetails: RepairPartnerDetailsModel.fromMap(map['repairPartnerDetails']),
    );
  }

  @override
  String toString() {
    return 'OrderModel(id: $id, receiverDetails: $receiverDetails, customer: $customer, orderDetailsModel: $orderDetailsModel, estimate: $estimate, deviceKyc: $deviceKyc, repairPartnerDetails: $repairPartnerDetails)';
  }

  // CopyWith method for easier updates
  OrderModel copyWith({
    String? id,
    ReceiverDetailsModel? receiverDetails,
    CustomerModel? customer,
    OrderDetailsModel? orderDetailsModel,
    EstimateModel? estimate,
    DeviceKycModels? deviceKyc, // Nullable deviceKyc
    RepairPartnerDetailsModel? repairPartnerDetails,
  }) {
    return OrderModel(
      id: id ?? this.id,
      receiverDetails: receiverDetails ?? this.receiverDetails,
      customer: customer ?? this.customer,
      orderDetailsModel: orderDetailsModel ?? this.orderDetailsModel,
      estimate: estimate ?? this.estimate,
      deviceKyc: deviceKyc ?? this.deviceKyc, // Handle nullable deviceKyc
      repairPartnerDetails: repairPartnerDetails ?? this.repairPartnerDetails,
    );
  }
}
