import 'package:flutter/material.dart';

class AccessoriesModel {
  final String? id; // Nullable ID
  final bool isPowerAdapterChecked;
  final bool isKeyboardChecked;
  final bool isMouseChecked;
  final List<String> otherAccessories; // List of other accessories
  final String? additionalDetails;
  final bool isWarrantyChecked;
  final DateTime? warrantyDate;

  AccessoriesModel({
    this.id, // Nullable 'id'
    this.isPowerAdapterChecked = false,
    this.isKeyboardChecked = false,
    this.isMouseChecked = false,
    this.otherAccessories = const [],
    this.additionalDetails,
    this.isWarrantyChecked = false,
    this.warrantyDate,
  });

  // Convert the model to a map (for Appwrite Database operations)
  Map<String, dynamic> toMap() {
    return {
      'isPowerAdapterChecked': isPowerAdapterChecked,
      'isKeyboardChecked': isKeyboardChecked,
      'isMouseChecked': isMouseChecked,
      'otherAccessories': otherAccessories,
      'additionalDetails': additionalDetails,
      'isWarrantyChecked': isWarrantyChecked,
      'warrantyDate': warrantyDate?.toIso8601String(),
    };
  }

  // Create a model from a map (useful for parsing Appwrite's response)
  factory AccessoriesModel.fromMap(Map<String, dynamic> map, {String? id}) {
    return AccessoriesModel(
      id: id, // Use the document ID from Appwrite response (nullable)
      isPowerAdapterChecked: map['isPowerAdapterChecked'] ?? false,
      isKeyboardChecked: map['isKeyboardChecked'] ?? false,
      isMouseChecked: map['isMouseChecked'] ?? false,
      otherAccessories: List<String>.from(map['otherAccessories'] ?? []),
      additionalDetails: map['additionalDetails'],
      isWarrantyChecked: map['isWarrantyChecked'] ?? false,
      warrantyDate: map['warrantyDate'] != null
          ? DateTime.parse(map['warrantyDate'])
          : null,
    );
  }

  @override
  String toString() {
    return 'AccessoriesModel(id: $id, isPowerAdapterChecked: $isPowerAdapterChecked, '
        'isKeyboardChecked: $isKeyboardChecked, isMouseChecked: $isMouseChecked, '
        'otherAccessories: $otherAccessories, additionalDetails: $additionalDetails, '
        'isWarrantyChecked: $isWarrantyChecked, warrantyDate: $warrantyDate)';
  }

  // CopyWith method for easier updates
  AccessoriesModel copyWith({
    String? id,
    bool? isPowerAdapterChecked,
    bool? isKeyboardChecked,
    bool? isMouseChecked,
    List<String>? otherAccessories,
    String? additionalDetails,
    bool? isWarrantyChecked,
    DateTime? warrantyDate,
  }) {
    return AccessoriesModel(
      id: id ?? this.id,
      isPowerAdapterChecked: isPowerAdapterChecked ?? this.isPowerAdapterChecked,
      isKeyboardChecked: isKeyboardChecked ?? this.isKeyboardChecked,
      isMouseChecked: isMouseChecked ?? this.isMouseChecked,
      otherAccessories: otherAccessories ?? this.otherAccessories,
      additionalDetails: additionalDetails ?? this.additionalDetails,
      isWarrantyChecked: isWarrantyChecked ?? this.isWarrantyChecked,
      warrantyDate: warrantyDate ?? this.warrantyDate,
    );
  }
}
