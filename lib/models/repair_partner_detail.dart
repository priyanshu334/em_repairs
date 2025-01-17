class RepairPartnerDetailsModel {
  final String id; // 'id' is now required and non-nullable
  final bool isInHouse;
  final bool isServiceCenter;
  final String? selectedOperator; // Only for in-house repairs
  final String? selectedServiceCenter; // Only for service center repairs
  final DateTime? pickupDate; // Only for service center repairs
  final String? pickupTime; // Only for service center repairs

  RepairPartnerDetailsModel({
    required this.id, // 'id' is now required
    required this.isInHouse,
    required this.isServiceCenter,
    this.selectedOperator,
    this.selectedServiceCenter,
    this.pickupDate,
    this.pickupTime,
  });

  /// Convert the model to a JSON map for storage
  Map<String, dynamic> toMap() {
    return {
      'id': id, // Include 'id' in the map
      'isInHouse': isInHouse,
      'isServiceCenter': isServiceCenter,
      'selectedOperator': selectedOperator,
      'selectedServiceCenter': selectedServiceCenter,
      'pickupDate': pickupDate?.toIso8601String(),
      'pickupTime': pickupTime, // Pickup time as string
    };
  }

  /// Create a model instance from a JSON map
  factory RepairPartnerDetailsModel.fromMap(Map<String, dynamic> map, {required String documentId}) {
    return RepairPartnerDetailsModel(
      id: documentId, // 'id' is now required
      isInHouse: map['isInHouse'] ?? false,
      isServiceCenter: map['isServiceCenter'] ?? false,
      selectedOperator: map['selectedOperator'],
      selectedServiceCenter: map['selectedServiceCenter'],
      pickupDate: map['pickupDate'] != null
          ? DateTime.parse(map['pickupDate'])
          : null,
      pickupTime: map['pickupTime'], // Pickup time as string
    );
  }

  /// Validation logic for ensuring correct field usage
  bool validate() {
    if (isInHouse && isServiceCenter) {
      throw Exception('Both isInHouse and isServiceCenter cannot be true.');
    }
    if (isInHouse && (selectedOperator == null || selectedOperator!.isEmpty)) {
      throw Exception('Selected operator is required for in-house repairs.');
    }
    if (isServiceCenter &&
        (selectedServiceCenter == null ||
            selectedServiceCenter!.isEmpty ||
            pickupDate == null ||
            pickupTime == null ||
            pickupTime!.isEmpty)) {
      throw Exception(
          'Service center, pickup date, and pickup time are required for service center repairs.');
    }
    return true;
  }

  @override
  String toString() {
    return 'RepairPartnerDetailsModel(id: $id, isInHouse: $isInHouse, isServiceCenter: $isServiceCenter, selectedOperator: $selectedOperator, selectedServiceCenter: $selectedServiceCenter, pickupDate: $pickupDate, pickupTime: $pickupTime)';
  }

  /// CopyWith method for easier updates
  RepairPartnerDetailsModel copyWith({
    String? id,
    bool? isInHouse,
    bool? isServiceCenter,
    String? selectedOperator,
    String? selectedServiceCenter,
    DateTime? pickupDate,
    String? pickupTime,
  }) {
    return RepairPartnerDetailsModel(
      id: id ?? this.id,
      isInHouse: isInHouse ?? this.isInHouse,
      isServiceCenter: isServiceCenter ?? this.isServiceCenter,
      selectedOperator: selectedOperator ?? this.selectedOperator,
      selectedServiceCenter: selectedServiceCenter ?? this.selectedServiceCenter,
      pickupDate: pickupDate ?? this.pickupDate,
      pickupTime: pickupTime ?? this.pickupTime,
    );
  }
}
