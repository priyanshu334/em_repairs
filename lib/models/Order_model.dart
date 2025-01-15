import 'package:em_repairs/models/DeviceKycModels.dart';
import 'package:em_repairs/models/customer_model.dart';

import 'package:em_repairs/models/order_details_models.dart';
import 'package:em_repairs/models/receiver_model.dart';
import 'package:em_repairs/models/repair_partner_detail.dart';
import 'package:em_repairs/models/estimate_form.dart';
import 'package:flutter/material.dart';

class OrderModel {
  final String? id; // Make 'id' nullable
  final Map<String, dynamic>? receiverDetailsModel; // Change to Map<String, dynamic>?
  final Map<String, dynamic>? customerModel; // Change to Map<String, dynamic>?
  final Map<String, dynamic>? orderDetailsModel; // Change to Map<String, dynamic>?
  final Map<String, dynamic>? estimateModel; // Change to Map<String, dynamic>?
  final Map<String, dynamic>? deviceKycModels; // Change to Map<String, dynamic>?
  final Map<String, dynamic>? repairPartnerDetailsModel; // Change to Map<String, dynamic>?

  OrderModel({
    this.id, // 'id' is now optional
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
      'receiverDetailsModel': receiverDetailsModel,
      'customerModel': customerModel,
      'orderDetailsModel': orderDetailsModel,
      'estimateModel': estimateModel,
      'deviceKycModels': deviceKycModels,
      'repairPartnerDetailsModel': repairPartnerDetailsModel,
    };
  }

  // Create a model from a map (useful for parsing Appwrite responses)
  factory OrderModel.fromMap(Map<String, dynamic> map, {String? documentId}) {
    return OrderModel(
      id: documentId, // 'id' is now optional and can be null
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
