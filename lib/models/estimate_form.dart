import 'package:flutter/material.dart';

class EstimateModel {
  final String id; // 'id' is now required and non-nullable
  final double repairCost;
  final double advancePaid;
  final DateTime? pickupDate;
  final String? pickupTime; // 'pickupTime' remains nullable

  EstimateModel({
    required this.id, // 'id' is required
    required this.repairCost,
    required this.advancePaid,
    required this.pickupDate,
    required this.pickupTime,
  });

  // Convert the model to a map (for database operations)
  Map<String, dynamic> toMap() {
    return {
      'id': id, // Include 'id' in the map if needed for updates
      'repairCost': repairCost,
      'advancePaid': advancePaid,
      'pickupDate': pickupDate?.toIso8601String(),
      'pickupTime': pickupTime, // Directly use the string representation
    };
  }

  // Create a model from a map
  factory EstimateModel.fromMap(Map<String, dynamic> map, {required String documentId}) {
    return EstimateModel(
      id: documentId, // 'id' is now required
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
