import 'package:flutter/material.dart';

class EstimateModel {
  final String? id; // Make 'id' nullable
  final double repairCost;
  final double advancePaid;
  final DateTime? pickupDate;
  final String? pickupTime; // Change pickupTime to String

  EstimateModel({
    this.id, // Nullable 'id'
    required this.repairCost,
    required this.advancePaid,
    required this.pickupDate,
    required this.pickupTime,
  });

  // Convert the model to a map (for Appwrite Database operations)
  Map<String, dynamic> toMap() {
    return {
      'repairCost': repairCost,
      'advancePaid': advancePaid,
      'pickupDate': pickupDate?.toIso8601String(),
      'pickupTime': pickupTime, // Directly use the string representation
    };
  }

  // Create a model from a map (useful for parsing Appwrite's response)
  factory EstimateModel.fromMap(Map<String, dynamic> map, {String? documentId}) {
    return EstimateModel(
      id: documentId, // Use the document ID from Appwrite response (nullable)
      repairCost: (map['repairCost'] ?? 0).toDouble(),
      advancePaid: (map['advancePaid'] ?? 0).toDouble(),
      pickupDate: map['pickupDate'] != null
          ? DateTime.parse(map['pickupDate'])
          : null,
      pickupTime: map['pickupTime'], // Directly use the string value
    );
  }

  @override
  String toString() {
    return 'EstimateModel(id: $id, repairCost: $repairCost, advancePaid: $advancePaid, pickupDate: $pickupDate, pickupTime: $pickupTime)';
  }

  // CopyWith method for easier updates
  EstimateModel copyWith({
    String? id,
    double? repairCost,
    double? advancePaid,
    DateTime? pickupDate,
    String? pickupTime, // Updated to String
  }) {
    return EstimateModel(
      id: id ?? this.id,
      repairCost: repairCost ?? this.repairCost,
      advancePaid: advancePaid ?? this.advancePaid,
      pickupDate: pickupDate ?? this.pickupDate,
      pickupTime: pickupTime ?? this.pickupTime,
    );
  }
}
