import 'package:em_repairs/models/order_details_models.dart';
import 'package:flutter/material.dart';
import 'package:em_repairs/models/customer_model.dart';
import 'package:em_repairs/models/device_kyc_model.dart';
import 'package:em_repairs/models/estimate_form.dart';
import 'package:em_repairs/models/receiver_model.dart';
import 'package:em_repairs/models/repair_partner_detail.dart';

class OrderModel {
  final String? id; // Make 'id' nullable
  final ReceiverDetailsModel receiverDetails;
  final CustomerModel customer;
  final OrderDetailsModel orderDetailsModel;
  final EstimateModel estimate;
  final DeviceKycModel deviceKyc;
  final RepairPartnerDetailsModel repairPartnerDetails;

  OrderModel({
    this.id, // 'id' is now optional
    required this.receiverDetails,
    required this.customer,
    required this.orderDetailsModel,
    required this.estimate,
    required this.deviceKyc,
    required this.repairPartnerDetails,
  });

  // Convert the model to a map (for database operations)
  Map<String, dynamic> toMap() {
    return {
      'id': id, // 'id' is now optional
      'receiverDetails': receiverDetails.toMap(),
      'customer': customer.toMap(),
      'orderDetailsModel': orderDetailsModel.toMap(),
      'estimate': estimate.toMap(),
      'deviceKyc': deviceKyc.toMap(),
      'repairPartnerDetails': repairPartnerDetails.toMap(),
    };
  }

  // Create a model from a map (useful for parsing database responses)
factory OrderModel.fromMap(Map<String, dynamic> map) {
  return OrderModel(
    id: map['id'], // 'id' is now optional and can be null
    receiverDetails: ReceiverDetailsModel.fromMap(map['receiverDetails']),
    customer: CustomerModel.fromMap(map['customer']),
    orderDetailsModel: OrderDetailsModel.fromMap(map['orderDetailsModel']),
    estimate: EstimateModel.fromMap(map['estimate']),
    deviceKyc: DeviceKycModel.fromMap(map['deviceKyc']),
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
    DeviceKycModel? deviceKyc,
    RepairPartnerDetailsModel? repairPartnerDetails,
  }) {
    return OrderModel(
      id: id ?? this.id,
      receiverDetails: receiverDetails ?? this.receiverDetails,
      customer: customer ?? this.customer,
      orderDetailsModel: orderDetailsModel ?? this.orderDetailsModel,
      estimate: estimate ?? this.estimate,
      deviceKyc: deviceKyc ?? this.deviceKyc,
      repairPartnerDetails: repairPartnerDetails ?? this.repairPartnerDetails,
    );
  }
}
  