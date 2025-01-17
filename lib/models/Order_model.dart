import 'package:em_repairs/models/DeviceKycModels.dart';
import 'package:em_repairs/models/customer_model.dart';
import 'package:em_repairs/models/order_details_models.dart';
import 'package:em_repairs/models/receiver_model.dart';
import 'package:em_repairs/models/repair_partner_detail.dart';
import 'package:em_repairs/models/estimate_form.dart';
import 'package:flutter/material.dart';

class OrderModel {
  final String id; // 'id' is now required and non-nullable
  final Map<String, dynamic>? receiverDetailsModel; // Nullable Map<String, dynamic>
  final Map<String, dynamic>? customerModel; // Nullable Map<String, dynamic>
  final Map<String, dynamic>? orderDetailsModel; // Nullable Map<String, dynamic>
  final Map<String, dynamic>? estimateModel; // Nullable Map<String, dynamic>
  final Map<String, dynamic>? deviceKycModels; // Nullable Map<String, dynamic>
  final Map<String, dynamic>? repairPartnerDetailsModel; // Nullable Map<String, dynamic>

  OrderModel({
    required this.id, // 'id' is required and non-nullable
    this.receiverDetailsModel, // Nullable Map<String, dynamic>
    this.customerModel, // Nullable Map<String, dynamic>
    this.orderDetailsModel, // Nullable Map<String, dynamic>
    this.estimateModel, // Nullable Map<String, dynamic>
    this.deviceKycModels, // Nullable Map<String, dynamic>
    this.repairPartnerDetailsModel, // Nullable Map<String, dynamic>
  });

  // Convert the model to a map (for Appwrite database operations)
  Map<String, dynamic> toMap() {
    return {
      'id': id, // Include the required id in the map
      'receiverDetailsModel': receiverDetailsModel,
      'customerModel': customerModel,
      'orderDetailsModel': orderDetailsModel,
      'estimateModel': estimateModel,
      'deviceKycModels': deviceKycModels,
      'repairPartnerDetailsModel': repairPartnerDetailsModel,
    };
  }

  // Create a model from a map (useful for parsing Appwrite responses)
  factory OrderModel.fromMap(Map<String, dynamic> map, {required String documentId}) {
    return OrderModel(
      id: documentId, // 'id' is required
      receiverDetailsModel: map['receiverDetailsModel'],
      customerModel: map['customerModel'],
      orderDetailsModel: map['orderDetailsModel'],
      estimateModel: map['estimateModel'],
      deviceKycModels: map['deviceKycModels'],
      repairPartnerDetailsModel: map['repairPartnerDetailsModel'],
    );
  }

  @override
  String toString() {
    return 'OrderModel(id: $id, receiverDetails: $receiverDetailsModel, customer: $customerModel, orderDetailsModel: $orderDetailsModel, estimate: $estimateModel, deviceKyc: $deviceKycModels, repairPartnerDetails: $repairPartnerDetailsModel)';
  }

  // CopyWith method for easier updates
  OrderModel copyWith({
    String? id,
    Map<String, dynamic>? receiverDetails,
    Map<String, dynamic>? customer,
    Map<String, dynamic>? orderDetailsModel,
    Map<String, dynamic>? estimate,
    Map<String, dynamic>? deviceKyc,
    Map<String, dynamic>? repairPartnerDetails,
  }) {
    return OrderModel(
      id: id ?? this.id,
      receiverDetailsModel: receiverDetails ?? this.receiverDetailsModel,
      customerModel: customer ?? this.customerModel,
      orderDetailsModel: orderDetailsModel ?? this.orderDetailsModel,
      estimateModel: estimate ?? this.estimateModel,
      deviceKycModels: deviceKyc ?? this.deviceKycModels,
      repairPartnerDetailsModel: repairPartnerDetails ?? this.repairPartnerDetailsModel,
    );
  }
}
