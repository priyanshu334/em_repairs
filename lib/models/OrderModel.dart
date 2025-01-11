import 'package:flutter/material.dart';

class OrderModel {
  final String id; // Unique identifier for the order

  // Customer Details
  final String customerName;
  final String customerPhone;
  final String customerAddress;

  // Receiver Details
  final String receiverName;
  final bool isOwner;
  final bool isStaff;

  // Device Details
  final String deviceModel;
  final List<String> problems;

  // Device KYC Details
  final bool powerAdapterChecked;
  final bool keyboardChecked;
  final bool mouseChecked;
  final bool warrantyChecked;
  final String accessories;
  final String details;
  final DateTime warrantyDate;
  final List<int> lockCode;
  final List<int> patternCode;

  // Estimate Form Details
  final String repairCost;
  final String advancePaid;
  final DateTime pickupDate;
  final TimeOfDay pickupTime;

  // Repair Partner Details
  final bool isInHouse;
  final bool isServiceCenter;
  final String selectedServiceCenter;
  final String selectedOperator;

  // Order Status
  final String orderStatus;

  // Constructor
  OrderModel({
    required this.id, // ID is now required
    required this.customerName,
    required this.customerPhone,
    required this.customerAddress,
    required this.receiverName,
    required this.isOwner,
    required this.isStaff,
    required this.deviceModel,
    required this.problems,
    required this.powerAdapterChecked,
    required this.keyboardChecked,
    required this.mouseChecked,
    required this.warrantyChecked,
    required this.accessories,
    required this.details,
    required this.warrantyDate,
    required this.lockCode,
    required this.patternCode,
    required this.repairCost,
    required this.advancePaid,
    required this.pickupDate,
    required this.pickupTime,
    required this.isInHouse,
    required this.isServiceCenter,
    required this.selectedServiceCenter,
    required this.selectedOperator,
    required this.orderStatus,
  });

  // Convert model to a map for database storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'customerName': customerName,
      'customerPhone': customerPhone,
      'customerAddress': customerAddress,
      'receiverName': receiverName,
      'isOwner': isOwner,
      'isStaff': isStaff,
      'deviceModel': deviceModel,
      'problems': problems,
      'powerAdapterChecked': powerAdapterChecked,
      'keyboardChecked': keyboardChecked,
      'mouseChecked': mouseChecked,
      'warrantyChecked': warrantyChecked,
      'accessories': accessories,
      'details': details,
      'warrantyDate': warrantyDate.toIso8601String(),
      'lockCode': lockCode,
      'patternCode': patternCode,
      'repairCost': repairCost,
      'advancePaid': advancePaid,
      'pickupDate': pickupDate.toIso8601String(),
      'pickupTime': '${pickupTime.hour}:${pickupTime.minute.toString().padLeft(2, '0')}',
      'isInHouse': isInHouse,
      'isServiceCenter': isServiceCenter,
      'selectedServiceCenter': selectedServiceCenter,
      'selectedOperator': selectedOperator,
      'orderStatus': orderStatus,
    };
  }

  // Create a model from a map
  factory OrderModel.fromMap(Map<String, dynamic> map, String id) {
    return OrderModel(
      id: id, // Assign the document ID
      customerName: map['customerName'],
      customerPhone: map['customerPhone'],
      customerAddress: map['customerAddress'],
      receiverName: map['receiverName'],
      isOwner: map['isOwner'],
      isStaff: map['isStaff'],
      deviceModel: map['deviceModel'],
      problems: List<String>.from(map['problems']),
      powerAdapterChecked: map['powerAdapterChecked'],
      keyboardChecked: map['keyboardChecked'],
      mouseChecked: map['mouseChecked'],
      warrantyChecked: map['warrantyChecked'],
      accessories: map['accessories'],
      details: map['details'],
      warrantyDate: DateTime.parse(map['warrantyDate']),
      lockCode: List<int>.from(map['lockCode']),
      patternCode: List<int>.from(map['patternCode']),
      repairCost: map['repairCost'],
      advancePaid: map['advancePaid'],
      pickupDate: DateTime.parse(map['pickupDate']),
      pickupTime: TimeOfDay(
        hour: int.parse(map['pickupTime'].split(':')[0]),
        minute: int.parse(map['pickupTime'].split(':')[1]),
      ),
      isInHouse: map['isInHouse'],
      isServiceCenter: map['isServiceCenter'],
      selectedServiceCenter: map['selectedServiceCenter'],
      selectedOperator: map['selectedOperator'],
      orderStatus: map['orderStatus'],
    );
  }
}
