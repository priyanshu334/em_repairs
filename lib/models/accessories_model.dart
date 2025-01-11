class AccessoriesModel {
  String? id; // Optional ID field for identifying documents (if required)
  bool isPowerAdapterChecked;
  bool isKeyboardChecked;
  bool isMouseChecked;
  List<String> otherAccessories; // List of other accessories
  String? additionalDetails;
  bool isWarrantyChecked;
  DateTime? warrantyDate;

  AccessoriesModel({
    this.id, // Optional id for Appwrite or database
    this.isPowerAdapterChecked = false,
    this.isKeyboardChecked = false,
    this.isMouseChecked = false,
    this.otherAccessories = const [],
    this.additionalDetails,
    this.isWarrantyChecked = false,
    this.warrantyDate,
  });

  // Convert the model to a map for database or API use
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

  // Create a model from a map (useful for API/database responses)
  factory AccessoriesModel.fromMap(Map<String, dynamic> map, {String? id}) {
    return AccessoriesModel(
      id: id, // Set the ID if available
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
}
